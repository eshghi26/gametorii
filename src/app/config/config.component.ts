import { Component } from '@angular/core';
import { ConfigService } from '../config.service';

@Component({
  selector: 'app-config',
  templateUrl: './config.component.html',
  styleUrls: ['./config.component.css']
})
export class ConfigComponent {
  maxNumber: number = 100;  // Default value, you can change this as needed
  message: string = '';

  constructor(private configService: ConfigService) {}

  saveConfig() {
    this.configService.saveConfig(this.maxNumber).subscribe(
      response => this.message = 'Configuration saved successfully',
      error => this.message = 'Error: ' + error.message
    );
  }
}
