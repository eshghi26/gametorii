import { Component } from '@angular/core';
import { GameService } from '../game.service';

@Component({
  selector: 'app-game',
  templateUrl: './game.component.html',
  styleUrls: ['./game.component.css']
})
export class GameComponent {
  guess: number = 0;
  message: string = '';

  constructor(private gameService: GameService) {}

  makeGuess() {
    this.gameService.makeGuess(this.guess).subscribe(
      response => this.message = response.message,
      error => this.message = 'Error: ' + error.message
    );
  }
}
