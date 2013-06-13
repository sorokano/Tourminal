function initcontrol() {
    $("#divValidation").hide();

    $(".spanDistrict").hide();
    $(".spanCity").hide();

    populateComboboxNoParam('ddlCountry', 'http://http://tourminal.ru//ElcondorWCF.svc/GetCountryListJS', true);
    //
    $("#hrefAdvSearch").click(function (e) {
        $("#divAdvancedSearch").toggle();
    });

    $("#ddlCountry").change(function (e) {
        if ($(this).val() != -1) {
            $(".spanDistrict").show();
            var param = "countryId=" + $(this).val();
            populateCombobox('ddlDistrict', 'http://tourminal.ru/ElcondorWCF.svc/GetDistrictListJS', true, param);
        } else {
            $(".spanDistrict").hide();
            $(".spanCity").hide();
        }
    });

    $("#ddlDistrict").change(function (e) {
        if ($(this).val() != -1) {
            $(".spanCity").show();
            var param = "districtId=" + $(this).val();
            populateCombobox('ddlCity', 'http://tourminal.ru/ElcondorWCF.svc/GetCityListByDistrictJS', true, param);
        } else {
            $(".spanCity").hide();
        }
    });

    $("#btn-search").click(sendSearchQuery);
}