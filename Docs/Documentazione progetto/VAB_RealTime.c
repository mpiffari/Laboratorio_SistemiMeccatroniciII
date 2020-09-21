#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <alchemy/task.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#define MAX_LINE_LENGTH 100
#define WINDOW_WIDTH 200

#define TEMP_FILE_NAME "/home/Laboratorio_SistemiMeccatroniciII/functions/GainParametersToController.txt"
#define CONFIRMED_FILE_NAME "/home/Laboratorio_SistemiMeccatroniciII/functions/GainParametersConfirmed.txt"
RT_TASK hello_task;
double calcola_m_a(double*);

double k_simulazione_discreta[4];
double phi = 0;
double phi_precedente = 0;
double phi_p = 0;
double theta = 0;
double theta_precedente = 0;
double theta_p = 0;
double Ts = 0.001;
double phi_p_setpoint = 10;

double m_a_phi[WINDOW_WIDTH];
double m_a_phi_p[WINDOW_WIDTH];
double m_a_theta[WINDOW_WIDTH];
double m_a_theta_p[WINDOW_WIDTH];
double m_a_motore [WINDOW_WIDTH];

double integrator_controller = 0;
double integrator_controller_motor = 0;
double K_integrazione = 0.002;
double desidered_cm = 0;
double actual_cm = 0;

void read_k(){
	// Streams for file reading
	FILE* tempGainFile;
	FILE* confirmedGainFile;
	char* line = (char*) malloc(sizeof(char) * (MAX_LINE_LENGTH + 1));

	// First: try to open temp file (which temporary gains passed from opc ua client)
	tempGainFile = fopen(TEMP_FILE_NAME, "r");
	if(tempGainFile) {
		// Read temporary parameters
		printf("tempGainFile is open\n");
		int index = 0;

		while(fgets(line, (MAX_LINE_LENGTH + 1), tempGainFile) != NULL) {
			if(index <= 3) {
				char* token = strtok(line, " ");
				token = strtok(NULL, line); // Get the second token (the double value)

				printf("Gain value read: -> K%d = %s", index, token);
				k_simulazione_discreta[index] = atof(token);
				printf("Gain value parsed: -> K%d = %f\n", index, k_simulazione_discreta[index]);
			}
			index++;
		}
		fclose(tempGainFile);
		free(line);
	} else {
		// If there's no temporary passing file, try to open confirmed parameters
		confirmedGainFile = fopen(CONFIRMED_FILE_NAME, "r");
		if (confirmedGainFile) {
			// Read confirmed parameters
			printf("confirmedGainFile is open\n");
			int index = 0;

			while(fgets(line, (MAX_LINE_LENGTH + 1), confirmedGainFile) != NULL) {
				if(index <= 3) {
					char* token = strtok(line, " ");
					token = strtok(NULL, line); // Get the second token (the double value)

					printf("Gain value read: -> K%d = %s", index, token);
					k_simulazione_discreta[index] = atof(token);
					printf("Gain value parsed: -> K%d = %f\n", index, k_simulazione_discreta[index]);
				}
				index++;
			}
			fclose(confirmedGainFile);
			free(line);
		} else {
			printf("Error on parameters reading\n");
		}
	}
}

void controllore(){

	double cm_state_feedback  = k_simulazione_discreta[0]*phi + k_simulazione_discreta[1]*phi_p + k_simulazione_discreta[2]*theta + k_simulazione_discreta[3]*theta_p;
	double difference_phi_p  = phi_p - phi_p_setpoint;
	integrator_controller = integrator_controller + K_integrazione*Ts*difference_phi_p;
	desidered_cm = integrator_controller - cm_state_feedback;
}

void controllore_motore(int counter){
	//////////////////da verificare la media mobile, c'era un errore in matlab/////////////////
	double cm_setpoint = desidered_cm;
	double corrente_attuale_noise = rand();
	//////////////////////////////////da rivedere le costanti/////////////////////////////////
	double k_t = 0.1;
	double Ts = 0.0001;
	double P = 1;
	double I = 980;
	if(cm_setpoint > 2)
		cm_setpoint = 2;
	if(cm_setpoint <-2)
		cm_setpoint = -2;
	double corrente_setpoint = cm_setpoint/k_t;
	m_a_motore[counter] = corrente_attuale_noise;
	double media_pesata = calcola_m_a(m_a_motore);
	double corrente_filtrata = media_pesata;
	double differenza_corrente  = corrente_setpoint - corrente_filtrata;
	integrator_controller_motor = I*Ts*differenza_corrente + integrator_controller_motor;
	actual_cm = P*differenza_corrente + integrator_controller_motor;
}

void read_sensor_phi(int counter){
	m_a_phi [counter] =  rand();
	double media_pesata = calcola_m_a(m_a_phi);
	phi_precedente = phi;
	phi = media_pesata;
}

void read_sensor_theta(int counter){
	m_a_theta [counter] =  rand();
	double media_pesata = calcola_m_a(m_a_theta);
	theta_precedente = theta;
	theta = media_pesata;
}

void calculate_phi_p(int counter){
	m_a_phi_p[counter] = (phi-phi_precedente)/Ts;
	double media_pesata = calcola_m_a(m_a_phi_p);
	phi_p = media_pesata;
}

void calculate_theta_p(int counter){
	m_a_theta_p[counter] = (theta-theta_precedente)/Ts;
	double media_pesata = calcola_m_a(m_a_theta_p);
	theta_p = media_pesata;
}

double calcola_m_a(double* media_mobile){

	double media_pesata = 0;
	for(int i = 0; i<WINDOW_WIDTH;i++){
		media_pesata = media_pesata + 1/WINDOW_WIDTH * media_mobile[i];
	}
	return media_pesata;

}

void wrap() {
	printf("START");
	int counter = 0;
	RTIME period  = 1000000000;
  	rt_task_set_periodic(NULL,TM_NOW,period);
	RTIME now = rt_timer_read();
	RTIME before= now-period;
	while(1){
		now = rt_timer_read();
		Ts = (now - before)/1000000000;
		read_sensor_phi(counter);
		read_sensor_theta(counter);
		calculate_phi_p(counter);
		calculate_theta_p(counter);
		read_k();
		controllore();
		controllore_motore(counter);
		counter = (counter+1)%WINDOW_WIDTH;
		printf("Actual motor torque: %f\n", actual_cm);
		printf("Elapsed time: %llu\n",Ts);
		before= now;
	}

	return;
}


int main(int argc, char* argv[])
{
  char  str[10] ;
  printf("start task\n");
  sprintf(str,"hello");
  
  /* Create task
   * Arguments: &task,
   *            name,
   *            stack size (0=default),
   *            priority,
   *            mode (FPU, start suspended, ...)
   */  
  rt_task_create(&hello_task, str, 0, 50, 0);

  /*  Start task
   * Arguments: &task,
   *            task function,
   *            function argument
   */
  rt_task_start(&hello_task, &wrap, 0);
  pause();
}
