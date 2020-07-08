//
//  PatientenExport.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 06.03.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit

class PatientenExport: NSObject {

	public static func getHTML()->String
	{
		let image = UIImage(named: "brk_kompaktlogo.png")
		let data : NSData = UIImageJPEGRepresentation(image!, 1.0)! as NSData

		imageString = data.base64EncodedString(options: .lineLength64Characters)
		return html
	}
	static var imageString = ""

	static var html = """

	<!doctype html>
	<html>
	<head>
	<meta charset="utf-8">
	<title>Patienten</title>
	<link href="PatientenStyle.css" rel="stylesheet">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous">


	</head>

	<body>
		<div class="bodyArea">
			<div class="pageHeader">
				<table class="HeaderTable">
					<tr>
						<td class="headerColumn0">
							
							<img  src="data:image/jpeg;base64, \(imageString)" >
						</td>
						<td class="headerColumn1">
							<div class="headerColumn1">
								<p>Patientenerfassung - BRK Rhön-Grabfeld</p>
							</div>

						</td>
						<td class="headerColumn2">
							Stand: 09.12.2013 20:53:46
						</td>
					</tr>

				</table>

			</div>

			<div class="contentArea" style="height: 100%;">
				<table class="patientTable">
					<tr class="patientenTableHeader">
						<td class="nummer" rowspan="2">
							<p>Nummer</p>
						</td>
						<td class="geschlecht">
							m
						</td>
						<td class="geschlecht">
							w
						</td>
						<td rowSpan="1" colSpan="5" class="headerSichtung">
							Sichtung
						</td>
						<td rowspan="2" class="headerDiagnose">
						Diagnose
						</td>
						<td rowspan="2" class="boolColumn">
							<a class="far fa-square"></a><a> Stabil</a><br>
							<a class="far fa-square"></a><a> Schockraum</a><br>
							<a class="far fa-square"></a><a> intubiert</a>
						</td>
						<td class="Name" rowspan="1" style="border-bottom: 0px;">
							<a>Name</a>
						</td>
						<td class="einsatzmittel">
							Einsatzmittel
						</td>
						<td class="transportZiel">
							Transportziel
						</td>
					</tr>
					<tr class="patientenTableHeader">
						<td class="age" rowspan="1" colspan="2">Alter</td>
						<td class="categoryColumn" rowspan="1" style="background-color: red;">I</td>
						<td class="categoryColumn" rowspan="1" style="background-color: yellow;">II</td>
						<td class="categoryColumn" rowspan="1" style="background-color: greenyellow;">III</td>
						<td class="categoryColumn" rowspan="1" style="background-color: blue;">IV</td>
						<td class="categoryColumn" rowspan="1" style="background-color: black; color: white">V</td>
						<td class="Name" style="border-top: 0px;">
							<a>Vorname</a>
						</td>
						<td class="einsatzmittel">
							Transportzeit
						</td>
						<td class="transportZiel">
							<a class="far fa-square"></a><a> angemeldet</a>
						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="nummer" rowspan="2">
							<p></p>
						</td>
						<td class="geschlecht">
							<a>m</a>
						</td>
						<td class="geschlecht">
							<a>w</a><a class="" style="font-size: 24px; margin-left: -12px"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" >
							<a class="" style="font-size: 24px;"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" ></td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td rowspan="2" class="Diagnose">

						</td>
						<td rowspan="2" class="boolColumn">
							<a class="far fa-square"></a><a> Stabil</a><br>
							<a class="far fa-square"></a><a> Schockraum</a><br>
							<a class="far fa-square"></a><a> intubiert</a>
						</td>
						<td class="Name" rowspan="1" style="border-bottom: 0px;">
							Jonas
						</td>
						<td class="einsatzmittel">

						</td>
						<td class="transportZiel">

						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="age" rowspan="1" colspan="2">

						</td>

						<td class="Name" style="border-top: 0px;">
							Wehner
						</td>
						<td class="transportZeit">

						</td>
						<td class="transportZiel">
							<a class="far fa-square"></a><a> angemeldet</a>
						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="nummer" rowspan="2">
							<p></p>
						</td>
						<td class="geschlecht">
							<a>m</a>
						</td>
						<td class="geschlecht">
							<a>w</a><a class="" style="font-size: 24px; margin-left: -12px"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" >
							<a class="" style="font-size: 24px;"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" ></td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td rowspan="2" class="Diagnose">

						</td>
						<td rowspan="2" class="boolColumn">
							<a class="far fa-square"></a><a> Stabil</a><br>
							<a class="far fa-square"></a><a> Schockraum</a><br>
							<a class="far fa-square"></a><a> intubiert</a>
						</td>
						<td class="Name" rowspan="1" style="border-bottom: 0px;">
							Jonas
						</td>
						<td class="einsatzmittel">

						</td>
						<td class="transportZiel">

						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="age" rowspan="1" colspan="2">

						</td>

						<td class="Name" style="border-top: 0px;">
							Wehner
						</td>
						<td class="transportZeit">

						</td>
						<td class="transportZiel">
							<a class="far fa-square"></a><a> angemeldet</a>
						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="nummer" rowspan="2">
							<p></p>
						</td>
						<td class="geschlecht">
							<a>m</a>
						</td>
						<td class="geschlecht">
							<a>w</a><a class="" style="font-size: 24px; margin-left: -12px"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" >
							<a class="" style="font-size: 24px;"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" ></td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td rowspan="2" class="Diagnose">

						</td>
						<td rowspan="2" class="boolColumn">
							<a class="far fa-square"></a><a> Stabil</a><br>
							<a class="far fa-square"></a><a> Schockraum</a><br>
							<a class="far fa-square"></a><a> intubiert</a>
						</td>
						<td class="Name" rowspan="1" style="border-bottom: 0px;">
							Jonas
						</td>
						<td class="einsatzmittel">

						</td>
						<td class="transportZiel">

						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="age" rowspan="1" colspan="2">

						</td>

						<td class="Name" style="border-top: 0px;">
							Wehner
						</td>
						<td class="transportZeit">

						</td>
						<td class="transportZiel">
							<a class="far fa-square"></a><a> angemeldet</a>
						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="nummer" rowspan="2">
							<p></p>
						</td>
						<td class="geschlecht">
							<a>m</a>
						</td>
						<td class="geschlecht">
							<a>w</a><a class="" style="font-size: 24px; margin-left: -12px"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" >
							<a class="" style="font-size: 24px;"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" ></td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td rowspan="2" class="Diagnose">

						</td>
						<td rowspan="2" class="boolColumn">
							<a class="far fa-square"></a><a> Stabil</a><br>
							<a class="far fa-square"></a><a> Schockraum</a><br>
							<a class="far fa-square"></a><a> intubiert</a>
						</td>
						<td class="Name" rowspan="1" style="border-bottom: 0px;">
							Jonas
						</td>
						<td class="einsatzmittel">

						</td>
						<td class="transportZiel">

						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="age" rowspan="1" colspan="2">

						</td>

						<td class="Name" style="border-top: 0px;">
							Wehner
						</td>
						<td class="transportZeit">

						</td>
						<td class="transportZiel">
							<a class="far fa-square"></a><a> angemeldet</a>
						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="nummer" rowspan="2">
							<p></p>
						</td>
						<td class="geschlecht">
							<a>m</a>
						</td>
						<td class="geschlecht">
							<a>w</a><a class="" style="font-size: 24px; margin-left: -12px"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" >
							<a class="" style="font-size: 24px;"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" ></td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td rowspan="2" class="Diagnose">

						</td>
						<td rowspan="2" class="boolColumn">
							<a class="far fa-square"></a><a> Stabil</a><br>
							<a class="far fa-square"></a><a> Schockraum</a><br>
							<a class="far fa-square"></a><a> intubiert</a>
						</td>
						<td class="Name" rowspan="1" style="border-bottom: 0px;">
							Jonas
						</td>
						<td class="einsatzmittel">

						</td>
						<td class="transportZiel">

						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="age" rowspan="1" colspan="2">

						</td>

						<td class="Name" style="border-top: 0px;">
							Wehner
						</td>
						<td class="transportZeit">

						</td>
						<td class="transportZiel">
							<a class="far fa-square"></a><a> angemeldet</a>
						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="nummer" rowspan="2">
							<p></p>
						</td>
						<td class="geschlecht">
							<a>m</a>
						</td>
						<td class="geschlecht">
							<a>w</a><a class="" style="font-size: 24px; margin-left: -12px"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" >
							<a class="" style="font-size: 24px;"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" ></td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td rowspan="2" class="Diagnose">

						</td>
						<td rowspan="2" class="boolColumn">
							<a class="far fa-square"></a><a> Stabil</a><br>
							<a class="far fa-square"></a><a> Schockraum</a><br>
							<a class="far fa-square"></a><a> intubiert</a>
						</td>
						<td class="Name" rowspan="1" style="border-bottom: 0px;">
							Jonas
						</td>
						<td class="einsatzmittel">

						</td>
						<td class="transportZiel">

						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="age" rowspan="1" colspan="2">

						</td>

						<td class="Name" style="border-top: 0px;">
							Wehner
						</td>
						<td class="transportZeit">

						</td>
						<td class="transportZiel">
							<a class="far fa-square"></a><a> angemeldet</a>
						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="nummer" rowspan="2">
							<p></p>
						</td>
						<td class="geschlecht">
							<a>m</a>
						</td>
						<td class="geschlecht">
							<a>w</a><a class="" style="font-size: 24px; margin-left: -12px"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" >
							<a class="" style="font-size: 24px;"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" ></td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td rowspan="2" class="Diagnose">

						</td>
						<td rowspan="2" class="boolColumn">
							<a class="far fa-square"></a><a> Stabil</a><br>
							<a class="far fa-square"></a><a> Schockraum</a><br>
							<a class="far fa-square"></a><a> intubiert</a>
						</td>
						<td class="Name" rowspan="1" style="border-bottom: 0px;">
							Jonas
						</td>
						<td class="einsatzmittel">

						</td>
						<td class="transportZiel">

						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="age" rowspan="1" colspan="2">

						</td>

						<td class="Name" style="border-top: 0px;">
							Wehner
						</td>
						<td class="transportZeit">

						</td>
						<td class="transportZiel">
							<a class="far fa-square"></a><a> angemeldet</a>
						</td>
					</tr>
						<tr class="patientTableRow">
						<td class="nummer" rowspan="2">
							<p></p>
						</td>
						<td class="geschlecht">
							<a>m</a>
						</td>
						<td class="geschlecht">
							<a>w</a><a class="" style="font-size: 24px; margin-left: -12px"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" >
							<a class="" style="font-size: 24px;"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" ></td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td rowspan="2" class="Diagnose">

						</td>
						<td rowspan="2" class="boolColumn">
							<a class="far fa-square"></a><a> Stabil</a><br>
							<a class="far fa-square"></a><a> Schockraum</a><br>
							<a class="far fa-square"></a><a> intubiert</a>
						</td>
						<td class="Name" rowspan="1" style="border-bottom: 0px;">
							Jonas
						</td>
						<td class="einsatzmittel">

						</td>
						<td class="transportZiel">

						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="age" rowspan="1" colspan="2">

						</td>

						<td class="Name" style="border-top: 0px;">
							Wehner
						</td>
						<td class="transportZeit">

						</td>
						<td class="transportZiel">
							<a class="far fa-square"></a><a> angemeldet</a>
						</td>
					</tr>
						<tr class="patientTableRow">
						<td class="nummer" rowspan="2">
							<p></p>
						</td>
						<td class="geschlecht">
							<a>m</a>
						</td>
						<td class="geschlecht">
							<a>w</a><a class="" style="font-size: 24px; margin-left: -12px"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" >
							<a class="" style="font-size: 24px;"></a>
						</td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td class="categoryColumn" rowspan="2" ></td>
						<td class="categoryColumn" rowspan="2" >
						</td>
						<td rowspan="2" class="Diagnose">

						</td>
						<td rowspan="2" class="boolColumn">
							<a class="far fa-square"></a><a> Stabil</a><br>
							<a class="far fa-square"></a><a> Schockraum</a><br>
							<a class="far fa-square"></a><a> intubiert</a>
						</td>
						<td class="Name" rowspan="1" style="border-bottom: 0px;">
							Jonas
						</td>
						<td class="einsatzmittel">

						</td>
						<td class="transportZiel">

						</td>
					</tr>
					<tr class="patientTableRow">
						<td class="age" rowspan="1" colspan="2">

						</td>

						<td class="Name" style="border-top: 0px;">
							Wehner
						</td>
						<td class="transportZeit">

						</td>
						<td class="transportZiel">
							<a class="far fa-square"></a><a> angemeldet</a>
						</td>
					</tr>

				</table>

			</div>


		</div>
	</body>
	<style>
	\(style)
	</style>
	</html>


	"""


	static var style = """
	/* CSS Document */

	.organisationIcon{

		height: 80px;

	}

	.pageheader {

	}

	.headerColumn0{
		border: 0px;
		width: 18%;
	}

	.headerColumn1{

		align-content: center;
		margin: 0 auto;
		border: 0px;
		text-align: center;
		font-weight: 600;
		font-size: 24px;
	}

	.headerColumn2{
		border: 0px;
		width: 18%;
		font-size: 12px;
		vertical-align: bottom;
		text-align: right;
		padding-left: 10px;
	}



	.HeaderTable{
		width: 100%;

		border: 0px;



	}

	.bodyArea{
		background-color: white;
		margin: 0px;
		padding-left: 10px;
		padding-right: 10px;
		padding-top: 10px;
		padding-bottom: 10px;
	}


	.patientTable{
		width: 100%;


	}

	.headerSichtung{
		width: 10%;
		text-align: center;
	}

	.headerDiagnose{
		width: 30%;
		text-align: center;
	}

	.categoryColumn{
		width: 2%;
		text-align: center;
	}

	.patientenTableHeader{
		height: 30px;
		font-weight: 600;
	}

	.patientTableRow{
		height: 47px;
		font-weight: 400;
	}

	.nummer{
		text-align: center;
		vertical-align: top;
		width: 8%;

	}

	.age{
		text-align: center;
		padding: 4px;
	}



	.geschlecht{

		width: 4%;
		text-align: center;
		height: 25px;
	}

	.boolColumn
	{
		width: 8%;
	}

	.Name{
		width: 10%;
		text-align: center;
	}

	.einsatzmittel{
		width: 12%;
		text-align: center;
	}


	.transportZeit{
		width: 12%;
		text-align: center;
	}

	.transportZiel{
		width: 12%;
		text-align: center;
	}

	table, th, td {
	  border: 2px solid black;
	  border-collapse: collapse;
	}

	body{
		 height: 595px;
			width: 1570px;
			/* to centre page on screen*/
			margin-left: auto;
			margin-right: auto;
			font-family: Arial, Helvetica, sans-serif;


	}



	"""

}
