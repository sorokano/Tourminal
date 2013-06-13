<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Flight.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.ServiceModel.Syndication" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Поиск и бронирование авиабилетов
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ddlRoutes").change(function (e) {
//                if ($(this).val() == 12) {
//                    document.location = 'http://www.tourminal.ru/Home/Page?id=21';
//                    return false;
//                } else 
                if ($(this).val() == 13) {
                    document.location = 'http://www.tourminal.ru/Home/Page?id=21';
                    return false;
                } else if ($(this).val() == 14) {
                    document.location = 'http://www.tourminal.ru/Home/Page?id=21';
                    return false;
                } else {
                    document.location = 'http://www.tourminal.ru/FlightTickets?routeId=' + $(this).val();
                }
            });

            $("#txtFlightDate").datepicker($.datepicker.regional['ru']);
            hideshow('loading', 0);
            $(".feedflare").hide();
            $(".btnview").click(function () {
                $('#txtFlightDate').text('<%= ViewData["RouteId"] %>');
                $("#routeName").val($(this).attr('name'));
                $('#itemId').val($(this).attr('id'));
                $('#datefrom').val($(this).attr('name'));
                //$('#routeName').val($(this).find('img').attr('alt'));
                //routeName_
                //$('#itemName').val('<%= ViewData["RouteName"] %>');
                $('#txtDlgItemName').val("");
                $('#dialog-book').dialog('open');
            });
            //$(".three_columns_mid").width(990);
            $("#headermap").height(90);

            //$(".three_columns_right").hide();
            if ($.query.get("routeId") == '') {
                $("#hrefCharter").addClass('selected');
                $("#divFlightCharter").show();
                $("#divFlightRegular").hide();
                $("#divFlightInfo").hide();
				$("#sectionTitle").text('Чартерные рейсы из Санкт-Петербурга');
            } else {
                $("#hrefCharter").addClass('selected');
                $("#divFlightCharter").show();
                $("#divFlightRegular").hide();
                $("#divFlightInfo").hide();
                $("#sectionTitle").text('Чартерные рейсы из Санкт-Петербурга');
            }
            $("#hrefCharter").click(function () {
                $("#hrefCharter").addClass('selected');
                $("#hrefRegular").removeClass('selected');
                $("#hrefInfo").removeClass('selected');
                $("#divFlightCharter").show();
                $("#divFlightRegular").hide();
                $("#divFlightInfo").hide();
                $("#sectionTitle").text('Чартерные рейсы из Санкт-Петербурга');
            });
            $("#hrefRegular").click(function () {
                $("#hrefCharter").removeClass('selected');
                $("#hrefRegular").addClass('selected');
                $("#hrefInfo").removeClass('selected');
                $("#divFlightCharter").hide();
                $("#divFlightRegular").show();
                $("#divFlightInfo").hide();
                $("#sectionTitle").text('Поиск и бронирование авиабилетов');
            });
            $("#hrefInfo").click(function () {
                $("#hrefCharter").removeClass('selected');
                $("#hrefRegular").removeClass('selected');
                $("#hrefInfo").addClass('selected');
                $("#divFlightCharter").hide();
                $("#divFlightRegular").hide();
                $("#divFlightInfo").show();
                $("#sectionTitle").text('Поиск и бронирование авиабилетов');
            });
            $("#dialog-book").dialog({
                autoOpen: false,
                resizable: false,
                height: 600,
                width: 720,
                modal: true,
                title: 'Подтвердите бронирование билета',
                buttons: {
                    'Закрыть': function () {
                        $(this).dialog('close');
                    }
                },
                close: function () {
                    //$('#txtDlgItemId').val("");
                    //$('#txtDlgTagSize').val("");
                    //location.reload();
                }
            });
        });
    </script>
    <div id="menutour" class="ddsmoothmenu-tour">
        <ul>
            <li><a href="#" id="hrefCharter">Чартеры</a></li>  
			<li><a href="#" id="hrefRegular">Авиабилеты</a></li>                      
            <li><a href="#" id="hrefInfo">Полезная информация</a></li>
            
        </ul>
    </div>
    <br />

    <span class="mainTitle">
        <h1 id="sectionTitle">Поиск и бронирование авиабилетов</h1>
    </span>
    <div style="margin-bottom: 30px; padding-top: 20px;">        
        <div style="margin-top: -20px;" id="divFlightRegular">
            <h3>Регулярные авиарейсы</h3>
            <!-- Affiliate form generated code -->
<script type="text/javascript">
$(document).ready(function() {
$("#regularframe").hide();
$('#regularframe').load(function() {
   	$("#regularframe").show();
	//$(this).sizeIFrame();

//setTimeout(iResize, 50);
//document.getElementById('regularframe').style.height = 
//    document.getElementById('regularframe').contentWindow.document.body.offsetHeight + 'px';
});
function iResize() {
    document.getElementById('regularframe').style.height = 
    document.getElementById('regularframe').contentWindow.document.body.offsetHeight + 'px';
}
});           
</script>
<script type="text/javascript">

  SETTINGS_HOST = "//nano.aviasales.ru";
  TP_FORM_SETTINGS = {
	"main": {
		"marker": "17617",
		"width": 670,
		"white_label_host": "",
		"show_logo": false,
		"show_hotels": null,
		"form_type": "avia",
		"currency": "rub",
		"sizes": "default",
		"search_target": "regularframe",
		"origin_iata": "",
		"destination_iata": "",
		"origin_name": null,
		"destination_name": null
	},
	"color_scheme": {
		"icons": "icons_blue",
		"background": "#ffffff",
		"color": "#000000",
		"border_color": "#c1c1c1",
		"button": "#1b9ed9",
		"button_text_color": "#ffffff"
	}
};
  (function(){
    var code = ['<div class="aviasales_inlineable">',
      '<div style="visibility: hidden;" data-widgets-forms-inlineable="{&quot;forms&quot;:&quot;search&quot;,&quot;link&quot;:&quot;/widgets/510e8191a0f0191c12000016.json?locale=ru&quot;}">',
      '<div class="nano_form_tabs_wp ultra_narrow_tabs">',
      '<div class="nano_form_tabs" data-widgets-forms-inlineable-tabs="">',
      '</div></div></div></div>'];
    var loader_url = SETTINGS_HOST + '/assets/nano_ui/widgets/partners/loader_ru.js?no_cache=' + (+new Date());
      code.push('<' + 'script src="' + loader_url + '">' + '<' +'/script>');
    document.write(code.join(''));
  })();

</script>
<iframe id="regularframe" style="width:670px;border:0;height:100%;min-height:500px;overflow-x: hidden; overflow-y: scroll"></iframe>
            <% List<LinqToElcondor.TblFlight> list = ElcondorBiz.BizFlight.GetHotFlights();
               StringBuilder sbHot = new StringBuilder();
                sbHot.Append("<ul>");
                foreach (LinqToElcondor.TblFlight flight in list.Take(5)) {
                    LinqToElcondor.TblRoute rt = ElcondorBiz.BizFlight.GetRouteById(flight.RouteId);
                    bool isTwoWay = flight.FlightOWStatusId == Elcondor.UI.Utilities.Constants.FlightOWStatusBothWays;
                    string routeNameFull = string.Empty;
                    string flightDatesFull = string.Empty;
                    switch (flight.FlightOWStatusId) {
                        case Elcondor.UI.Utilities.Constants.FlightOWStatusBothWays:
                            routeNameFull = "Cанкт-Петербург - " + rt.Name + " - Санкт-Петербург";
                            flightDatesFull = flight.FlightDateThere.Value.ToString("dd.MM.yyyy") + " - " + flight.FlightDateBack.Value.ToString("dd.MM.yyyy");
                            break;
                        case Elcondor.UI.Utilities.Constants.FlightOWStatusThere:
                            routeNameFull = "Cанкт-Петербург - " + rt.Name;
                            flightDatesFull = flight.FlightDateThere.Value.ToString("dd.MM.yyyy");
                            break;
                        case Elcondor.UI.Utilities.Constants.FlightOWStatusBack:
                            routeNameFull = rt.Name + " - Санкт-Петербург";
                            flightDatesFull = flight.FlightDateBack.Value.ToString("dd.MM.yyyy");
                            break;
                    }
                    
                    sbHot.Append(string.Format("<li><a href=\"../../FlightTickets?routeId={0}\" style=\"text-decoration:none !important;color:#000 !important;\"><b>{1}</b>, {2} <b>{3}</b></a></li>"
                                , flight.RouteId, routeNameFull 
                                , flightDatesFull , flight.Price));
                }
                
                sbHot.Append("</ul>");
                string hotDeals = sbHot.ToString();
            %>
            <% if (list.Count > 0) { %>
            <hr class='dashes' />
            <br />
            <h3>Лучшие предложения</h3>
            <%= sbHot.ToString() %>
            <%} %>
            <%--<table class="">
                <tr>
                    <td></td>
                </tr>
            </table>--%>
            <hr class='dashes' />
            <h3>Новости</h3>
            <% 
                var reader = XmlReader.Create("http://feeds.feedburner.com/aviasalesru?format=xml");
                var feed = SyndicationFeed.Load(reader);
                sbHot = new StringBuilder();
                sbHot.Append("<div id=\"content\">");
                sbHot.Append("<section id=\"offers\">");
                foreach (SyndicationItem itm in feed.Items.Take(5)) {
                    if (itm.Links.Count() > 0) {
                        sbHot.Append("<section class=\"offer\">");
                        sbHot.Append("<header>");
                        sbHot.Append(string.Format("<a href=\"{1}\">{0}</a>", itm.Title.Text, itm.Links[0].Uri));
                        sbHot.Append("</header>");

                        sbHot.Append(string.Format("<footer>{0}</footer><a href=\"{1}\">Перейти к новости</a></section><br/>", itm.Summary.Text, itm.Links[0].Uri));
                        
                    }
                }
                sbHot.Append("</div></div>");
            %>
            <%= sbHot.ToString() %>
            <%= ViewData["FlightRegular"]%>
        </div>
        <div style="margin-top: -30px;" id="divFlightCharter">
            <%--<h3>Чартерные авиарейсы из Санкт-Петербурга</h3>
            <br />--%>
            
            <br />
            <%--<table class="flightlist">
                <% StringBuilder sb = new StringBuilder();
                   sb.Append("<tr style=\"background:#fcf7da;\">");
                   sb.Append(string.Format("<td colspan=\"7\" style=\"font-weight:bold;font-size:22px;border:0 !important;\">{0}</td>", "Лучшие предложения"));
                   sb.Append("</tr>");
                    foreach (LinqToElcondor.TblFlight flight in ElcondorBiz.BizFlight.GetHotFlights()) {
                        string routeName = ElcondorBiz.BizFlight.GetRouteById(flight.RouteId).Name;
                        bool isHot = flight.IsHot.HasValue ? flight.IsHot.Value : false;
                        bool isTwoWay = flight.FlightOWStatusId == Elcondor.UI.Utilities.Constants.FlightOWStatusBothWays;
                        string imgOWStatus = "<img src=\"../../Content/Images/arrowround.png\" style=\"height:20px\"/>";
                        switch (flight.FlightOWStatusId) {
                            case Elcondor.UI.Utilities.Constants.FlightOWStatusBack:
                                imgOWStatus = "<img src=\"../../Content/Images/arrowleft.png\" style=\"height:18px\" />";
                                break;
                            case Elcondor.UI.Utilities.Constants.FlightOWStatusThere:
                                imgOWStatus = "<img src=\"../../Content/Images/arrowright.png\" style=\"height:18px\" />";
                                break;
                        }
                        string flightThereText = flight.FlightOWStatusId == Elcondor.UI.Utilities.Constants.FlightOWStatusBack 
                            ? string.Empty 
                            : string.Format(
                                "<span style=\"font-size:14px;font-weight:bold;\">{0}</span><br/><span style=\"color:#6d6e70;font-size:12px;\">{1}</span><br/>{2}"
                                , flight.FlightDateThere.Value.ToString("dd.MM.yyyy")
                                , flight.FlightNumberThere
                                , flight.FlightTimeThere);
                        string flightBackText = flight.FlightOWStatusId == Elcondor.UI.Utilities.Constants.FlightOWStatusThere 
                            ? string.Empty
                            : string.Format(
                                "<span style=\"font-size:14px;font-weight:bold;\">{0}</span><br/><span style=\"color:#6d6e70;font-size:12px;\">{1}</span><br/>{2}"
                                , flight.FlightDateBack.Value.ToString("dd.MM.yyyy")
                                , flight.FlightNumberBack
                                , flight.FlightTimeBack);
                        sb.Append(string.Format("<tr align=center>"));
                           
                        sb.Append(string.Format(
"<td style=\"width: 120px;font-weight:bold;font-size:16px;text-align:left\">{7}</td><td style=\"width: 170px\">{0}</td><td style=\"width: 35px\"><span style=\"color:#6d6e70;\">{1}</span></td><td style=\"width: 170px\">{2}</td><td style=\"width: 60px\"><span style=\"color:#6d6e70;\">{3}</span></td><td style=\"font-size:{8}px;font-weight:bold;width:100px;\">{4}</td><td style=\"width: 100px\"><a href=\"#\" class=\"btnbook\" id=\"{5}\" name=\"{6}\">Бронировать</a></td></tr>"
                            , flightThereText
                            , imgOWStatus
                            , flightBackText
                            , isTwoWay ? ((TimeSpan)(flight.FlightDateBack - flight.FlightDateThere)).TotalDays.ToString() : "ow"
                            , flight.Price
                            , flight.Id
                            , routeName + " (" + flight.FlightDateThere.Value.ToString("dd.MM.yyyy") + " - " + flight.FlightDateBack.Value.ToString("dd.MM.yyyy") + ")"
                            , routeName
                            , flight.Price == "по запросу" ? "16" : "20"
                        ));
                    }
                   %>
                   <%= sb.ToString() %>
            </table>--%>
            <h3>Лучшие предложения</h3>
            <%= hotDeals %>
            <br />
           <%-- <%= ViewData["GridCharterRouteListHTML"] %>
            <%= ViewData["GridFlightListHTML"]%>--%>
            <table class="tickets">
                <%--<tr>
                    <th></th>
                    <%--<th>Дата вылета</th><th></th><th></th>--%>
                    <%--Вылет</td><td></td><td>Прилет</td><td>Дата вылета</td><td></td><td></td>
                    
                </tr>--%>
                <tr>
                    <td>
                        <h3>Город назначения:</h3> <%= Html.DropDownList("ddlRoutes", (IEnumerable<SelectListItem>)ViewData["ddlRoutes"], new { style = "width:365px;" })%> 
                    </td>
                    <%--<td>
                        <%= Html.TextBox("txtFlightDate", "не указана", new { style = "width:85px" })%>
                    </td>--%>
                    <%--<td>
                        <img src="../../Content/Images/imgcalendar.png" alt="" />
                    </td>--%>
                    <%--<td>
                        <a href="#"><img src="../../Content/Images/btnsearch.jpg" alt="Найти" /></a>
                    </td>--%>
                </tr>
            </table>
            
            <br />
            <table class="flightlist">
                <tr>
                    <th style="width: 80px">
                    </th>
                    <th style="width: 170px">
                        <img src="../../Content/Images/flightfrom.png" />
                    </th>
                    <th style="width: 90px">

                    </th>
                    <th style="width: 170px">
                        <img src="../../Content/Images/flightto.png" />
                    </th>
                    <th style="width: 60px">   
                        Кол-во ночей
                    </th>
                    <th style="width: 100px">
                        Цена 
                    </th>
                    <th style="width: 100px">
                        <img src="../../Content/Images/iconinfo.png" />
                    </th>
                </tr>
               
                   <%= ViewData["GridRouteFlights"] %>
            </table>
        </div>
        <div style="margin-top: -20px;" id="divFlightInfo">
            <%--<h2>Полезная информация</h2>--%>
            <%= ViewData["FlightInfo"]%>
        </div>
    
    <br /><br />
    <div class="anchor"></div>
    <div id="dialog-book">
        <%--<% using (Html.BeginForm("SendTourBookMessage", "Home", FormMethod.Post, new { autocomplete = "off" })) { %>--%>
        <form method="post" id="msgTicketForm" style="margin: 0 auto;" action="../../verifyTicketBooking.php">
        <h2>
            <label id="routeName"><%= ViewData["RouteName"] %>
            </label>
        </h2>
        <div id="errorContact" class="error">&nbsp;</div>
        <table class="tblsimple">
            <tr>
                <td>
                    <span style="color:red">*</span> Ваше имя:
                </td>
                <td>
                    <div class="input-container">
                        <input name="nameContact" id="nameContact" type="text" />
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <span style="color:red">*</span> Ваш контактный Email:
                </td>
                <td>
                    <div class="input-container">
                        <input name="emailContact" id="emailContact" type="text" />
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <span style="color:red">*</span> Ваш контактный телефон:
                </td>
                <td>
                    <div class="input-container">
                        <input name="phoneContact" id="phoneContact" type="text" />
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    Дата вылета:
                </td>
                <td>
                    <%= Html.TextBox("datefrom", string.Empty, new { style = "width:300px;", disabled = "disabled" })%>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <span style="color: #000; margin-bottom: 5px;">Присоединить сообщение:</span><br />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="input-container">
                        <textarea name="contentContact" id="contentContact" rows="4" cols="70"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <span style="color: #000; margin-bottom: 5px;">Введите текст на картинке:</span><br />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div id="captchaitm">
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" id="btnsubmit"  class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="float: right;" value="Отправить сообщение" />
                    <img id="loading" src="../../Content/Images/ajax-wait.gif" alt="working.." style="float: right;
                        margin-right: 5px; padding-top: 2px;" />
                </td>
            </tr>
        </table>
        <input name="itemId" id="itemId" type="text" style="display: none;" />
        <input name="itemName" id="itemName" type="text" style="display: none;" />
        <%-- <br />
             <br />--%>
        <%--<%= Html.TextArea("txtDlgMessage", string.Empty, 5, 55, new { name = "txtDlgMessage" })%>
            </fieldset>--%>
        <%--<%= Html.TextBox("txtDlgItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>--%>
        <%--<br /><br />--%>
        <%--<input type="submit" value="Подтвердить бронирование" id="btnSave" name="btnEditItem" value="edititem" />--%>
        <%--<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button" role="button" aria-disabled="false">
                <span class="ui-button-text">Подтвердить бронирование</span>
            </button>--%>
        </form>
        
    </div>
</asp:Content>
