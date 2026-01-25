/*
Translate Dutch terms in the interface to English for Manuscript
*/

$("option:contains('6. (Categorical) Whole group')").html(
  "6. (Categorical) Whole Group (N: 36) - 12 December 2024"
);

/* Main Text
Binary
*/

main_question = 'Zou u de behandeling gericht op herstel voortzetten?'
main_question_en = 'Would you continue Life Sustaining Therapy?'
$el = $(`h1:contains('${main_question}')`);
question = $el.html()
if(question) {
  $el.html(
    question.replace(
      main_question,
      main_question_en
      )
    )
  }

/*
Column Headers
- To allow the full level text to display
*/

$("th:contains('Criteria')").css("width","50%")
$("th:contains('Score')").css("width","50%")
$("th:contains('Score')").html("Level")

/*
Font size
*/
$('.form-control').css('font-size','16px')
$('body').css('font-size','16px')


/*
Categories
*/
$("td p:contains('Ja, met Time Limited Trial')").html(
  "Continue with Time Limited Trial"
);

$("td p:contains('Ja')").html(
  "Continue life-sustaining therapy"
);


$("td p:contains('Nee, stoppen')").html(
  "Withdraw life-sustaining therapy"
);


/*
Expected additional ICU length of stay
*/

$("td p:contains('Verwachte IC-opnameduur')").html(
  "Expected additional ICU length of stay"
);

$("option:contains('Enkele weken')").html(
  "A couple of weeks"
);

$("option:contains('Enkele maanden')").html(
  "A couple of months"
);


/*
Clinical Situation
*/
$("td p:contains('Klinische verwachting')").html(
  "Clinical Situation"
);

$("option:contains('Verslechtering')").html(
  "Deterioration"
);

$("option:contains('Geen verbetering')").html(
  "No improvement"
);

/*
Age (years)
*/

$("td p:contains('Leeftijd')").html(
  "Age"
);


$("option:contains('40 Jaar')").html(
  "40 years"
);

$("option:contains('55 Jaar')").html(
  "55 years"
);

$("option:contains('70 Jaar')").html(
  "70 years"
);

$("option:contains('85 Jaar')").html(
  "85 years"
);

/*
Frailty at hospital admission
*/

$("td p:contains('Frailty bij ziekenhuisopname')").html(
  "Frailty at hospital admission"
);


/*
Life expectancy (pre-admission)
*/

$("td p:contains('Op basis van de comorbiditeit was de levensverwachting vóór IC opname')").html(
  "Life expectancy before ICU admission"
);

$("option:contains('6 - 12 maanden')").html(
  "6 - 12 months"
);

$("option:contains('1 - 5 jaar')").html(
  "1 - 5 years"
);

$("option:contains('> 5 jaar')").html(
  "> 5 years"
);

/*
Burden of Suffering
*/

$("td p:contains('Actuele lijdenslast (inschatting door het behandelteam)')").html(
  "Burden of Suffering"
);

$("option:contains('Beperkte lijdenslast')").html(
  "Limited"
);

$("option:contains('Ernstige lijdenslast')").html(
  "Severe"
);

/*
Impairment
- Moves the text above the first item above for better visualization
- Reshuffles first item (Cardiovascular)
*/

element_impairment = $("td p:contains('De verwachting is dat er na de IC-opname sprake zal zijn van de volgende beperkingen:')")
$('tr[style*="background-color:#ADD8E6"]').first().before(element_impairment)
if (element_impairment) {
  element_impairment.html("Expected impairment after ICU discharge:")
  element_impairment.css("padding", "7px")
  element_impairment.css("margin-bottom", "0")
  element_impairment.css("margin-top", "8px")
}

element_cardiovascular = $("td p:contains('Cardiaal')")

// removes empty container element from DOM
element_cardiovascular.parent().parent().prepend(element_cardiovascular)
element_cardiovascular.next().remove()


/*
Change Styles
*/

$('tr[style*="background-color:#ADD8E6"]').css("background-color", "");
$("tr td span:has(div)").css("width","100%")

/*
Cardiac
*/

$("td p:contains('Cardiaal')").html(
  "<li style='list-style-type: square;'>Cardiovascular</li>"
);

$("option:contains('NYHA I: normale inspanning geeft geen overmatige klachten')").html(
  "NYHA I"
);

$("option:contains('NYHA II: normale inspanning geeft overmatige klachten, maar geen klachten in rust')").html(
  "NYHA II"
);

$("option:contains('NYHA III: in rust weinig/geen klachten, lichte inspanning geeft overmatige klachten')").html(
  "NYHA III"
);

$("option:contains('NYHA IV: geen enkele inspanning mogelijk zonder klachten; ook klachten in rust')").html(
  "NYHA IV"
);


/*
Renal impairment
*/

$("td p:contains('Renaal')").html(
  "<li style='list-style-type: square;'>Renal</li>"
);

$("option:contains('Geen beperkingen (GFR > 30)')").html(
  "No impairment (GFR > 30)"
);

$("option:contains('pre-dialyse traject (GFR 15-30)')").html(
  "Pre-dialysis (GFR 15-30)"
);

$("option:contains('Dialyse (GFR <15)')").html(
  "Dialysis dependent (GFR < 15)"
);

/*
Pulmonary impairment

Note: since JQuery does not allow exact text matching using selectors modify most specific first
*/

$("td p:contains('Pulmonaal')").html(
  "<li style='list-style-type: square;'>Pulmonary</li>"
);


$("option:contains('Geen beperkingen')").html(
  "No impairment"
);

$("option:contains('Matige beperkingen')").html(
  "Moderate impairment"
);

$("option:contains('Ernstige beperkingen')").html(
  "Severe impairment"
);

/*
Neurological impairment

mRS 0-1
mRS 2-3
mRS 4-5
*/

$("td p:contains('Neurologisch')").html(
  "<li style='list-style-type: square;'>Neurological</li>"
);

/*
Gastro-intestinal impairment
*/

$("td p:contains('Gastro-intestinaal (sonde-voeding)')").html(
  "<li style='list-style-type: square;'>Gastro-intestinal (tube-feeding)</li>"
);

$("option:contains('Zonder sonde-voeding')").html(
  "Without tube-feeding"
);

$("option:contains('Met sonde-voeding')").html(
  "Tube-feeding dependent"
);

/*
Patient or Family Values
*/

$("td p:contains('Wens patiënt en/of familie')").html(
  "Patient or Family Values</li>"
);

$("option:contains('De verwachte toekomstige beperkingen zijn mogelijk acceptabel')").html(
  "Expected future physical disabilities are possibly acceptable"
);

$("option:contains('De verwachte toekomstige beperkingen zijn waarschijnlijk onacceptabel')").html(
  "Expected future physical disabilities are most likely unacceptable"
);



