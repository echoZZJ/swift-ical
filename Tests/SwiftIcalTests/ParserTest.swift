//
//  ParserTest.swift
//  SwiftIcalTests
//
//  Created by zijie zhang on 2021/5/23.
//

import Foundation
@testable import SwiftIcal
import XCTest

class ParserTests: XCTestCase {
    func testParse() {
        let strMock = """
        BEGIN:VCALENDAR
        PRODID:-//SwiftIcal/EN
        VERSION:2.0
        BEGIN:VFREEBUSY
        UID:4FD3AD926350
        DTSTAMP:20090602T190420Z
        DTSTART:20090602T000000Z
        DTEND:20090604T000000Z
        ORGANIZER;CN="Cyrus Daboo":mailto:cyrus@example.com
        ATTENDEE;CN="Wilfredo Sanchez Vega":mailto:wilfredo@example.com
        ATTENDEE;CN="Bernard Desruisseaux":mailto:bernard@example.net
        ATTENDEE;CN="Mike Douglass":mailto:mike@example.org
        END:VFREEBUSY
        END:VCALENDAR
        """
        VParser.parse(content: strMock)
    }
    
    func testMultiVfreeBusyParse() {
        let strMock = """
        BEGIN:VCALENDAR
        PRODID:-//SwiftIcal/EN
        VERSION:2.0
        BEGIN:VFREEBUSY
        UID:4FD3AD926350
        DTSTAMP:20090602T190420Z
        DTSTART:20090602T000000Z
        DTEND:20090604T000000Z
        ORGANIZER;CN="Cyrus Daboo01":mailto:cyrus@example.com01
        ATTENDEE;CN="Wilfredo Sanchez01 Vega":mailto:wilfredo@example.com01
        ATTENDEE;CN="Bernard Desruisseaux01":mailto:bernard@example.net01
        ATTENDEE;CN="Mike Douglass01":mailto:mike@example.org01
        FREEBUSY:20220314T233000Z/20220315T003000Z
        FREEBUSY:20220316T153000Z/20220316T163000Z
        FREEBUSY:20220318T030000Z/20220318T040000Z
        END:VFREEBUSY
        BEGIN:VFREEBUSY
        UID:4FD3AD926350
        DTSTAMP:20090602T190420Z
        DTSTART:20090602T000000Z
        DTEND:20090604T000000Z
        ORGANIZER;CN="Cyrus Daboo02":mailto:cyrus@example.com
        ATTENDEE;CN="Wilfredo Sanchez Vega02":mailto:wilfredo@example.com02
        ATTENDEE;CN="Bernard Desruisseaux02":mailto:bernard@example.net02
        ATTENDEE;CN="Mike Douglass02":mailto:mike@example.org02
        FREEBUSY:19980314T233000Z/19980315T003000Z
        FREEBUSY:19980316T153000Z/19980316T163000Z
        FREEBUSY:19980318T030000Z/19980318T040000Z
        END:VFREEBUSY
        END:VCALENDAR
        """
        
        VParser.parse(content: strMock)
    }
}
