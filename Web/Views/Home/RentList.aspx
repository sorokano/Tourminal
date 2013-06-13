<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Rent.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - туристическая компания: Поиск отелей
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% DateTime newDateTime = DateTime.Now.AddDays(7);
     %>
    <script type="text/javascript">         
        function log( message ) {
            $( "<div>" ).text( message ).prependTo( "#log" );
            $( "#log" ).scrollTop( 0 );
        }

        $(document).ready(function () {            
            $(".tdRegion").css("visibility","hidden");
            $(".tdCity").css("visibility","hidden");
            hideshow('loadingReg', 0);	            
            hideshow('loadingCity', 0);	     

            var countryItems = [<%= ViewData["CountryItems"] %>];
            $('#MainContent_ddlCountryList').checkList({
					listItems: countryItems,
					onChange: selChangeCountry
			});
            function selChangeCountry(){                                
				var selection = $('#MainContent_ddlCountryList').checkList('getSelection');					
                var result = '';
                var items = eval('(' + JSON.stringify(selection) + ')');
                for (var i = 0; i < items.length; i++) {
                    //alert( items[i].value + ' ' + items[i].text);
                    if (items[i].value == "|-1") {
                        result = "-1";
                        break;
                    }                        
                    result = result + '|' + items[i].value;
                }
                $("#txtCountries").val(result);
                if (result != '') {
                    hideshow('loadingReg', 1);	      
                    hideshow('loadingCity', 0);	   
                    $('input:checkbox.chk').prop("disabled", true);
                    $(".tdRegion").css("visibility","visible");
                    $.getJSON('../../TaratripWCF.svc/GetDistrictListForCountries' + "?method=?&" + "countries=" + result, function (response) {                           
                        var resultRegionJson = new Array();                      
                        var items = eval('(' + response + ')');
                        for (var i = 0; i < items.length; i++) {
                            if (items[i].value == "-1") {
                                result = "|-1";
                                break;
                            }
                            var myObject = new Object();
                            myObject.text = items[i].Name;
                            myObject.value = items[i].Id;
                            resultRegionJson.push(myObject);
                        }             
                        $('#MainContent_ddlRegion').checkList({
					            listItems: resultRegionJson,
					            onChange: selChangeRegion
			            });
                        $('#MainContent_ddlRegion').checkList('setData', resultRegionJson);      
                        hideshow('loadingCity', 0);	   
                        hideshow('loadingReg', 0);	  
                        $('input:checkbox.chk').prop("disabled", false);              
                        $(".toolbar .chkAllText").each(function () {
                            $(this).html("Все");
                        });    
                    });
                } else {
                    $(".tdRegion").css("visibility","hidden");
                    $(".tdCity").css("visibility","hidden");
                }
			}
            function selChangeRegion(){    
                $('input:checkbox.chk').prop("disabled", true);	      
				var selection = $('#MainContent_ddlRegion').checkList('getSelection');					
                var result = '';
                var items = eval('(' + JSON.stringify(selection) + ')');
                for (var i = 0; i < items.length; i++) {
                    result = result + '|' + items[i].value;
                }
                $("#txtRegions").val(result);
                if (result != '' && result != '-1') {
                    hideshow('loadingCity', 1);
                    $(".tdCity").css("visibility","visible");
                    $.getJSON('../../TaratripWCF.svc/GetCityListForRegions' + "?method=?&" + "regions=" + result, function (response) {
                        var resultRegionJson = new Array();                      
                        var items = eval('(' + response + ')');
                        for (var i = 0; i < items.length; i++) {
                            if (items[i].value == "-1") {
                                result = "|-1";
                                break;
                            }
                            var myObject = new Object();
                            myObject.text = items[i].Name;
                            myObject.value = items[i].Id;
                            resultRegionJson.push(myObject);
                        }
                        $('input:checkbox.chk').prop("disabled", false);
                        hideshow('loadingCity', 0);	                              
                        $('#MainContent_ddlCity').checkList({
					            listItems: resultRegionJson,
					            onChange: selChangeCity
			            });
                        $('#MainContent_ddlCity').checkList('setData', resultRegionJson);
                        $(".toolbar .chkAllText").each(function () {
                            $(this).html("Все");
                        });
                    });
                } else {
                    $(".tdCity").css("visibility","hidden");
                }
                $('input:checkbox.chk').prop("disabled", false);     
			}
            function selChangeCity(){    
				var selection = $('#MainContent_ddlCity').checkList('getSelection');					
                var result = '';
                var items = eval('(' + JSON.stringify(selection) + ')');
                for (var i = 0; i < items.length; i++) {
                    result = result + '|' + items[i].value;
                }
                $("#txtCities").val(result);
            }
//             $( "#txtCityRegion" ).autocomplete({
//                minLength: 0,
//                source: availableTags
//            });
            $("#tara_txtDatefrom").datepicker($.datepicker.regional['ru']);
            $("#tara_txtDateto").datepicker($.datepicker.regional['ru']);
            $("#btnSubmit").click(function (e) {
                e.preventDefault();                
                $("#searchform").submit();
                return false;
            });
            $('#tara_txtDatefrom').val("<%= DateTime.Now.ToString("dd.MM.yyyy") %>");
            $('#tara_txtDateto').val("<%= newDateTime.ToString("dd.MM.yyyy")%>");
            var qstring = $.query.get("formVars");
            var strs = qstring.split('||');
            if (qstring != '') {
                $.getJSON('../../TaratripWCF.svc/GetCityListByDistrict' + "?method=?&" + 'districtId=32', function (response) {
                    var result = "";
                    result += '<option value="-1">-- Все --</option>';
                    var items = eval('(' + response + ')');
                    for (var i = 0; i < items.length; i++) {
                        result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                    }
                    $("select#" + 'tara_ddlCity').html(result);
                    //$("#tara_ddlCity").val('<%= ViewData["CityId"]%>');
                    $("#tara_ddlCity").val(strs[0].substring(strs[0].indexOf('__') + 2, strs[0].length));
                });     
            }
            $(".toolbar .chkAllText").each(function () {
                $(this).html("Все");
            });
        });
        </script>
    <h1>
        Аренда вилл, апартаментов, поиск отеля
    </h1>
    <% using (Html.BeginForm("RentList", "Home", FormMethod.Post, new { id = "searchform" })) { %>
    <%--Меню слева--%>
    <%= Html.ValidationSummary("")%>
    <div style="width: 650px;padding-left:0px;margin-left: 0;margin-top:5px;">
        <div id="tarasearch-small">
            <table style="margin-bottom:2px;padding:0">
                <tr>
                    <td style="width: auto">
                        <div style="position: relative;display: block;">
                            <table>
                                <tr>
                                    <td class="tdCountry" style="vertical-align: top;">
                                        <div id="ddlCountryList" runat="server"></div>
                                    
                                    </td>
                                    <td class="tdRegion" style="vertical-align: top;">
                                        <div id="ddlRegion" runat="server"></div>
                                        <img id="loadingReg" src="../../Content/Images/ajax-wait.gif" alt="working.." style="float: right;margin-right: 5px; padding-top: 2px;" />
                                    </td>
                                    <td class="tdCity" style="vertical-align: top;">
                                        <div id="ddlCity" runat="server"></div>
                                        <img id="loadingCity" src="../../Content/Images/ajax-wait.gif" alt="working.." style="float: right;margin-right: 5px; padding-top: 2px;" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <%--<%= Html.TextBox("txtCityRegion", "Город, регион или пляж", new { style = "width: 450px;font-size:14px;color:#b1b4b6;height:30px !important;" })%>--%>
                    </td>
                    <td style="width: 150px;font-size: 12px;color:#b1b4b6;vertical-align:top;">Куда вы хотите отправиться?<br />Лондон, например?</td>
                    <td style="width: 95px;">&nbsp;</td>
                </tr>
            </table>
            <table style="margin-bottom:15px;padding:0">
                <tr>
                    <td style="width: 450px">
                        <%= Html.TextBox("tara_txtDatefrom", string.Empty, new { style = "width: 150px;font-size:14px;color:#000;height:30px !important;" })%>
                        &nbsp;<img src="../../Content/Images/iconcalendar.jpg" alt="" />                            
                         - <%= Html.TextBox("tara_txtDateto", string.Empty, new { style = "width: 150px;font-size:14px;color:#000;height:30px !important;" })%> 
                         &nbsp;<img src="../../Content/Images/iconcalendar.jpg" alt="" />
                    </td>
                    <td style="width: 150px;font-size: 12px;color:#b1b4b6;">Укажите удобные числа<br />или забронировать <a href="#">сейчас</a></td>
                    <td style="width: 95px;">&nbsp;</td>
                </tr>
            </table>
            <table style="margin-bottom:15px;padding:0">
                <tr>
                    <td style="width: 70px">
                        <%= Html.TextBox("txtAdults", "1", new { style = "width: 70px;font-size:14px;color:#b1b4b6;height:30px !important;" })%>
                    </td>
                    <td style="width: 30px">&nbsp;и&nbsp;</td>
                    <td>    
                        <%= Html.TextBox("txtKids", "0", new { style = "width: 70px;font-size:14px;color:#b1b4b6;height:30px !important;" })%>
                    </td>
                    <td rowspan="2" style="width: 445px;text-align: right;"><a href="#" id="btnSubmit"><img src="../../Content/Images/btnfindhotel.jpg" alt="" /></a></td>
                    <td></td>
                </tr>
                <tr>
                    <td style="width: 70px">
                        <span style="font-size:12px;color:#000;">взрослых</span>
                    </td>
                    <td></td>
                    <td style="width: 70px">
                        <span style="font-size:12px;color:#000;">детей</span>
                    </td>
                    <td></td>
                </tr>
            </table>
        </div>
        <%= Html.TextBox("txtCountries", "-1", new { style = "width: 70px;font-size:14px;color:#b1b4b6;display:none" })%>
        <%= Html.TextBox("txtRegions", "-1", new { style = "width: 70px;font-size:14px;color:#b1b4b6;display:none" })%>
        <%= Html.TextBox("txtCities", "-1", new { style = "width: 70px;font-size:14px;color:#b1b4b6;display:none" })%>
        <% } %>
        <%--Основной контент--%>
        
        <%--<h1></h1>
            <div id="divResultPanel">
               <div id="divSearchResult">
                    <%=  ViewData["SearchResultsGrid"]%>
                    <ul>
                    
                    </ul>
               </div>
            </div> --%>
        </div>
</asp:Content>
