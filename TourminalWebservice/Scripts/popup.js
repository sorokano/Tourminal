//REGISTRATION POPUP
var popupRegistrationStatus = 0;

function loadPopupRegistration(){
    if (popupRegistrationStatus == 0) {
		$("#backgroundPopup").css({
			"opacity": "0.7"
		});
		$("#backgroundPopup").fadeIn("slow");
		$("#popupRegistration").fadeIn("slow");
		popupRegistrationStatus = 1;
	}
}

function disablePopupRegistration() {
    if (popupRegistrationStatus == 1) {
		$("#backgroundPopup").fadeOut("slow");
		$("#popupRegistration").fadeOut("slow");
		popupRegistrationStatus = 0;
	}
}

function centerPopupRegistration() {
	var windowWidth = document.documentElement.clientWidth;
	var windowHeight = document.documentElement.clientHeight;
	var popupHeight = $("#popupRegistration").height();
	var popupWidth = $("#popupRegistration").width();
	$("#popupRegistration").css({
		"position": "absolute",
		"top": windowHeight/2-popupHeight/2,
		"left": windowWidth/2-popupWidth/2
	});
	//only need force for IE6	
	$("#backgroundPopup").css({
		"height": windowHeight
	});	
}

$(document).ready(function () {
    $(".hrefRegister").click(function () {
        centerPopupRegistration();
        loadPopupRegistration();
        return false;
    });

    $("#popupRegistrationClose").click(function () {
        disablePopupRegistration();
    });

    $("#backgroundPopup").click(function () {
        disablePopupRegistration();
    });

    $(document).keypress(function (e) {
        if (e.keyCode == 27 && popupRegistrationStatus == 1) {
            disablePopupRegistration();
        }
    });

});

//LOGON POPUP
var popupLogonStatus = 0;

function loadPopupLogon() {
    if (popupLogonStatus == 0) {
        $("#backgroundPopup").css({
            "opacity": "0.7"
        });
        $("#backgroundPopup").fadeIn("slow");
        $("#popupLogon").fadeIn("slow");
        popupLogonStatus = 1;
    }
}

function disablePopupLogon() {
    if (popupLogonStatus == 1) {
        $("#backgroundPopup").fadeOut("slow");
        $("#popupLogon").fadeOut("slow");
        popupLogonStatus = 0;
    }
}

function centerPopupLogon() {
    var windowWidth = document.documentElement.clientWidth;
    var windowHeight = document.documentElement.clientHeight;
    var popupHeight = $("#popupLogon").height();
    var popupWidth = $("#popupLogon").width();
    $("#popupLogon").css({
        "position": "absolute",
        "top": windowHeight / 2 - popupHeight / 2,
        "left": windowWidth / 2 - popupWidth / 2
    });
    //only need force for IE6	
    $("#backgroundPopup").css({
        "height": windowHeight
    });

}

$(document).ready(function () {
    $(".hrefLogon").click(function () {
        centerPopupLogon();
        loadPopupLogon();
        return false;
    });

    $("#popupLogonClose").click(function () {
        disablePopupLogon();
    });

    $("#backgroundPopup").click(function () {
        disablePopupLogon();
    });

    $(document).keypress(function (e) {
        if (e.keyCode == 27 && popupLogonStatus == 1) {
            disablePopupLogon();
        }
    });

});