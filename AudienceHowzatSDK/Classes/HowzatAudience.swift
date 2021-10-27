//
//  HowzatAudience.swift
//  AudienceHowzatSDK
//
//  Created by Subrahmanyam Pampana on 10/26/21.
//


import Foundation
import Starscream

public class HowzatAudience: WebSocketDelegate{
    
    public init(){}
    
    public  func printInstallationStatus(){
            print("Howzat Audience installation is success")
        }

          public  func test(){
            print("Howzat Audience installation is success")
        }

  
        var socket: WebSocket!
        var isConnected = false
        private  var baseUrl = "wss://cerebro.carromstars.com"
        let server = WebSocketServer()
        public func getAudienceUrl() {
            return baseUrl
        }
    
        public func setAudienceUrl(url: String) {
            baseUrl = url
        }
      
           public func initializeConnection(app: String, orgID: String, userID: String, token: String) {
               print("URL");
               print("\(baseUrl)/ws/\(orgID)/\(userID)/\(token)");
               var request = URLRequest(url: URL(string: "\(baseUrl)/ws/\(orgID)/\(userID)/\(token)")!)
               request.timeoutInterval = 5
               print("INIT CALLEDD");
               socket = WebSocket(request: request)
               socket.delegate = self
               socket.connect()
               
           }
           
          public func didReceive(event: WebSocketEvent, client: WebSocket) {
              print("inside didreceive");
              print(event);
              print(client);
               switch event {
               case .connected(let headers):
                   isConnected = true
                   print("websocket is connected: \(headers)")
               case .disconnected(let reason, let code):
                   isConnected = false
                   print("websocket is disconnected: \(reason) with code: \(code)")
               case .text(let string):
                   print("Received text: \(string)")
                   let data = convertToDictionary(text: string)
                   if(data?["action"] != nil) {
                       socket.write(string: string)
                   }
               case .binary(let data):
                   print("Received data: \(data.count)")
               case .ping(_):
                   break
               case .pong(_):
                   break
               case .viabilityChanged(_):
                   break
               case .reconnectSuggested(_):
                   break
               case .cancelled:
                   isConnected = false
               case .error(let error):
                   isConnected = false
                   handleError(error)
               }
           }
           
           func handleError(_ error: Error?) {
                   if let e = error as? WSError {
                       print("websocket encountered an error: \(e.message)")
                   } else if let e = error {
                       print("websocket encountered an error: \(e.localizedDescription)")
                   } else {
                       print("websocket encountered an error")
                   }
               }
           
           func convertToDictionary(text: String) -> [String: Any]? {
               if let data = text.data(using: .utf8) {
                   do {
                       return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                   } catch {
                       print(error.localizedDescription)
                   }
               }
               return nil
           }
}
