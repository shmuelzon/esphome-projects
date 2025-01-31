# Doorbell

This project is meant as a drop-in replacement to my existing doorbell buzzer. It uses the same infrastructure and illuminated push-button for activating it.

## Build

### Bill of Materials

| Name | Image | Quantity | Comments |
| ---- | ----- | -------- | -------- |
| SeeedStudio XIAO ESP32S3 |  ![XIAO ESP32S3](./xiao_esp32s3.jpg) | 1 | |
| MAX98357 I2S Audio Amplifier Module | ![MAX98357](./max98357.jpg) | 1 | |
| Transformer | ![Transformer](./transformer.jpg) | 1 | 220v -> 12v |
| AC-DC Power supply | ![Power supply](./power_supply.jpg) | 1 | 5v |
| AC Relay | ![AC Relay](./relay.jpg) | 1 | 12v AC |
| Terminal block | ![AC Relay](./terminal_block.jpg) | 4 | Split to two pairs |
| Speaker | ![Speaker](./speaker.jpg) | 1 | 4 Ohm, 3W |
| 100k resistor | ![100k resistor](./resistor.jpg) | 1 | Optional, set's the Amplifier to 15dB gain instead of 9dB |
| M3x10 bolts and nuts | ![M3x10 bolts and nuts](./bolts_and_nuts.jpg) | 4 | |

## Connections

MAX98357:
* LRC -> GPIO 44
* BCLK -> GPIO 7
* DIN -> GPIO 8
* Gain -> 100K resistor, the other end of the resistor to GND
* GND -> GND
* VIN -> 3.3v

Speaker:
* Red -> MAX98357 +
* Black -> MAX98357 -

Transformer:
* Primary (side with 2 pins) -> Live (AC) terminal block
* Secondary side -> One pin to the relay input and another to the button terminal block

Relay:
* Coil -> One side to the transformer, the other to the button terminal block
* Top contact (closer to the coil) -> GPIO 1
* Middle contact -> GND

AC-DC power supply:
* Mains -> Live (AC) terminal block
* 5v -> Xiao 5v
* GND -> GND

Live terminal block:
* AC Phase and neutral

Button terminal block:
* 2 leads to the illuminated doorbell push button

## Images
| Front | Back |
| ----- | ---- |
| ![Build 1](./build1.jpg) | ![Build 2](./build2.jpg) |

## Misc

### Media Player

The doorbell also functions as a Home Assistant media player meaning you can play any supported audio on it, as well as use text-to-speech actions on it for various notifications.

### MQTT

While Home Assistant already enumerates the button for automations and such, I also opted to enable MQTT so that other services, e.g., Scrypted, can get events when the doorbell is pressed. The topic for the button is `doorbell/binary_sensor/button/state` with a payload of `ON` or `OFF`.
