import Foundation
import Starscream

enum ResponseActionType: String {
    case SMINAPPLIST = "sm-inapp-list"
    case SMINAPP = "sm-inapp"
    case SMINAPPDELETE = "sm-inapp-delete"
}

public protocol SendResponseDelegate {
    func sendResponse(dataString: String)
}

public class HowzatAudience: WebSocketDelegate{
    
    public var responseDelegate: SendResponseDelegate!
    
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
    public func getAudienceUrl() -> String {
        return baseUrl
    }
    
    public func setAudienceUrl(url: String) {
        baseUrl = url
    }
    
    public func initializeConnection(app: String, orgID: String, userID: String, token: String, fullUrl: String) {
        var request: URLRequest;
        print("\(baseUrl)/ws/\(orgID)/\(userID)/\(token)");
        print("\(fullUrl)");
        if(fullUrl != "") {
            request = URLRequest(url: URL(string: "\(fullUrl)")!)
        } else {
            request = URLRequest(url: URL(string: "\(baseUrl)/ws/\(orgID)/\(userID)/\(token)")!)
        }
        
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        let timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { timer in
            
            self.socket.write(ping: Data()) {
                print("PING SENT SUCCESSFULLY");
            }
        })
    }
    
    func websocketDidConnect(ws: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription ?? "default value")")
        
    }
    
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        print("Received data: \(data.length)")
    }
    
    func websocketDidReceivePong(socket: WebSocket) {
        print("Got pong!")
    }
    
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connectedd: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnectedd: \(reason) with code: \(code)")
            self.socket.connect()
        case .text(let string):
            print("Received textt: \(string)")
            let data = convertToDictionary(text: string)
            
            if(data?["action"] != nil && (data?["action"] as! String == "sm-inapp" || data?["action"] as! String == "sm-inapp-list" || data?["action"] as! String == "sm-inapp-delete")) {
                let convertedData = convertToJsonString(from: data!) ?? ""
                responseDelegate.sendResponse(dataString: convertedData)
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            print("PONG RECEIVED")
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
            self.socket.connect()
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
    
    public func closeConnection() {
        print("DISCONNECTING");
        socket.disconnect();
    }
    
    public func requestInAppList(trackingID: String, notify: Bool) -> Bool {
        if(socket != nil) {
            let str = "{\"action\": \"cm-inapp-list\"}"
            let data = Data(str.utf8)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                socket.write(data: data);
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            return true;
        }
        
        return false
    }
    
    public func requestInAppDelete(trackingID: String, notify: Bool) -> Bool {
        if(socket != nil) {
            
            let str = "{\"action\": \"cm-inapp-delete\", \"data\": {\"trackingId\": \"\(String(trackingID))\", \"notify\": \"\(String(notify))\"}}"
            
            let data = Data(str.utf8)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                socket.write(data: data);
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            return true;
        }
        return false
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
    func convertToJsonString(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
}
