//
//  StammdatenProtocol.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import Foundation
protocol StammdatenDetailVCDelegate {
    func createdHospital(hospital : BaseHospital)
    func createdUnit(unit : BaseUnit)
    func createdUser(user : User)
    func createdDiagnose(diagnose : BaseInjury)
}
