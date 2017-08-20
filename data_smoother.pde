/*------------------------------------------------------------------------------
  Originally developed to work with the arduino using the StandardFirmata 
  library as detailed on http://playground.arduino.cc/Interfacing/Processing
  
  To use it with an arduino, set up an Arduino object as described above,
  and assign the pin data to the rawData variable in the draw() loop. 
  Ex: rawData = myArduino.analogRead(0);
  
  Using the Smoother class requires the following:
  
  1. initializing the object. 
     Ex: Smoother foo;
  2. instantiating the object in the setup() function
     Ex: foo = new Smoother(resolution);
  3. setting your data source in the draw() loop
     Ex: rawData = DATA SOURCE
  4. to smooth your data, use the member function average(rawData)
     Ex smoothedValue = foo.average(rawData);
     
  Note: The example data in this demo is randomized data between 0-1000. 
  The smoothed data should appear to waver around the midpoint (500).
  
------------------------------------------------------------------------------*/

// initialize smoother object
Smoother foo;

int rawData;
int smoothedValue;

void setup() {
  
  // instantiate smoother and set resolution
  foo = new Smoother(40);  
  
}

void draw() {
  
  // read data
  rawData = int(random(1000));                    // replace with your data source
  
  // smooth data
  smoothedValue = foo.average(rawData);    // use smoothed value
  println(smoothedValue);                           // print value to console

}

class Smoother {
  
  // init variables
  int numReadings;
  int[] readings;                     // the readings from the analog input (Array)
  int readIndex;                      // the index of the current reading
  int total;                          // the running total
  int average;                        // the average  
  
  // Constructor / Class Setup
  Smoother (int resolution) {
    numReadings = resolution;
    readings = new int[numReadings];  // the readings from the analog input (Array)
    readIndex = 0;                    // the index of the current reading
    total = 0;                        // the running total
    average = 0;                      // the average  
    
    for (int thisReading = 0; thisReading < numReadings; thisReading++) {
      readings[thisReading] = 0;
    } 
    
  }
 
  int average(int data) {
    total = total - readings[readIndex];          // subtract the last reading
    readings[readIndex] = data;                   // read from the sensor
    total = total + readings[readIndex];          // add the reading to the total
    readIndex = readIndex + 1;                    // advance to the next position in the array
    
    // if we're at the end of the array...
    if (readIndex >= numReadings) {
      // ...wrap around to the beginning:
      readIndex = 0;
    }
  
    average = total / numReadings;       // calculate the average
    delay(1);                            // delay in between reads for stability
    
    return average;                    
  }  
}