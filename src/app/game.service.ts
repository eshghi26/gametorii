import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class GameService {
  private apiUrl = 'http://gametoriapiservice:5169/api/game';

  constructor(private http: HttpClient) { }

  makeGuess(guess: number): Observable<any> {
    return this.http.post(`${this.apiUrl}/guess`, { guess });
  }
}
