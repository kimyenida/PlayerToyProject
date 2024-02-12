//
//  StreamAPIProcess.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation

class StreamAPIProcess:APIProcess{
    let networking = iMBCNetRouter<StreamApi>()
    
    //mbic
    func getMbicPlayerUtil(chid: String, type: String,_ completion: @escaping (Result<MbicUtilForm, ResponseError>) -> Void) {
        networking.request(.mbicUtil(chid: chid, type: type)) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
 
}
