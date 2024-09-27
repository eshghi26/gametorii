import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ConfigService {
  private apiUrl = 'http://apigametori.freehawk.site/api/admin';

  constructor(private http: HttpClient) { }

  saveConfig(maxNumber: number): Observable<any> {
    return this.http.post(`${this.apiUrl}/config`, { maxNumber });
  }
}
