//
//  Parser.swift
//  SwiftIcal
//
//  Created by zijie zhang on 2021/5/23.
//

import Foundation
import CLibical

class VParser {
    static func parse(content: String) {
//        let parser = icalparser_new()
        let cString = content.cString(using: .utf8)
        let comp = icalparser_parse_string(cString)
        let cfreeBusy = "VFREEBUSY".cString(using: .utf8)
        let freebusyComp = icalcomponent_get_first_component(comp, icalcomponent_string_to_kind(cfreeBusy))
        var nxtFBComp = icalcomponent_get_next_component(comp, icalcomponent_string_to_kind(cfreeBusy))
//        let freebusyComp = icalcomponent_get_next_component(comp,
//                                         icalcomponent_string_to_kind(cfreeBusy))
//        let freebusy = icalcomponent_get_comment(comp)
        let uid = icalcomponent_get_uid(freebusyComp)
        innerParserLogic(with: freebusyComp)
        while let nxtComp = nxtFBComp {
            innerParserLogic(with: nxtComp)
            nxtFBComp = icalcomponent_get_next_component(comp, icalcomponent_string_to_kind(cfreeBusy))
        }
        
//        let property  = icalcomponent_get_first_property(freebusyComp, icalproperty_string_to_kind(corg))
//        let orgInfo : String? =  .init(cString: icalproperty_get_organizer(property))
//        let uidString : String? = .init(cString: icalcomponent_get_uid(freebusyComp))
//        let day = icalcomponent_get_dtstamp(comp).day
//        print(orgInfo)
//        icalcomponent_isa_component(icalcomponent_new_vfreebusy())
        
        
    }
    
    static func innerParserLogic(with parsedCmp: LibicalComponent?) {
        guard let comp = parsedCmp else {
            return
        }
       
        let corg  = "ORGANIZER".cString(using: .utf8)
        let cattendee = "ATTENDEE".cString(using: .utf8)
        let fbPropertyCStr = "FREEBUSY".cString(using: .utf8)
        let fbParamtype = "FBTYPE".cString(using: .utf8)
       
        let orgproperty  = icalcomponent_get_first_property(comp, icalproperty_string_to_kind(corg))
        if icalproperty_get_organizer(orgproperty) != nil {
            let orgInfo : String? =  .init(cString: icalproperty_get_organizer(orgproperty))
            print(orgInfo)
        }
        let attendeefirstProp = icalcomponent_get_first_property(comp, icalproperty_string_to_kind(cattendee))
        var attendeesecondProp = icalcomponent_get_next_property(comp, icalproperty_string_to_kind(cattendee))
        if attendeefirstProp != nil {
            let firstAttendee : String? =  .init(cString: icalproperty_get_attendee(attendeefirstProp))
            print("||first attendee name is \(firstAttendee)")
            while attendeesecondProp != nil  {
                
                let attendeeInfo : String? =  .init(cString: icalproperty_get_attendee(attendeesecondProp))
                print("||second attendee name is \(attendeeInfo)")
                attendeesecondProp = icalcomponent_get_next_property(comp, icalproperty_string_to_kind(cattendee))
            }
        }
        if let fbProperty = icalcomponent_get_first_property(comp, icalproperty_string_to_kind(fbPropertyCStr)) {
            
            let start =  Date.dateFromicaltimetype(with: icalproperty_get_freebusy(fbProperty).start)
            let end = Date.dateFromicaltimetype(with: icalproperty_get_freebusy(fbProperty).end)
            print("-- first start is \(start), first end is \(end)")
            if let fbParm = icalproperty_get_first_parameter(fbProperty, icalparameter_string_to_kind(fbParamtype)) {
              //默认为 busy 时间段
              
            }
            while let nxtfbProperty = icalcomponent_get_next_property(comp, icalproperty_string_to_kind(fbPropertyCStr)) {
                let start = Date.dateFromicaltimetype(with: icalproperty_get_freebusy(nxtfbProperty).start)
                let end = Date.dateFromicaltimetype(with: icalproperty_get_freebusy(nxtfbProperty).end) 
                print("-- second start is \(start), second end is \(end)")
            }
        }
//        icalcomponent_get_first_property(<#T##component: OpaquePointer!##OpaquePointer!#>, icalproperty_string_to_kind(corg))
//        let fyvalue = icalproperty_get_first_parameter(<#T##prop: OpaquePointer!##OpaquePointer!#>, icalparameter_string_to_kind("FBTYPE"))
    }
}
extension String {


    init?(cString: UnsafeMutablePointer<Int8>?) {
        guard let cString = cString else { return nil }
        self = String(cString: cString)
    }

    init?(cString: UnsafeMutablePointer<CUnsignedChar>?) {
        guard let cString = cString else { return nil }
        self = String(cString: cString)
    }
}

extension Date {
    static func dateFromicaltimetype(with type: icaltimetype, timeZone: TimeZone = .current) -> Date {
        let calendar = Calendar.current
        let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: Int(type.year), month: Int(type.month), day: Int(type.day), hour: Int(type.hour), minute: Int(type.minute), second: Int(type.second))
        return comp.date!
    }

}
