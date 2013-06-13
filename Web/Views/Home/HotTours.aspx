<%@ Page Trace="true" Title="" Language="C#" MasterPageFile="~/Views/Shared/Tour.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - Все туры
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function selChangeCity(){}

        $(document).ready(function () {
            $("#i-country").change(function(e){
                $.getJSON('../../TaratripWCF.svc/GetCityListForCountries' + "?method=?&" + "countryId=" + $("#i-country").val(), function (response) {                           
                        var resultCityJson = new Array();                      
                        var items = eval('(' + response + ')');
                        for (var i = 0; i < items.length; i++) {
                            var myObject = new Object();
                            myObject.text = items[i].Name;
                            myObject.value = items[i].Id;
                            resultCityJson.push(myObject);
                        }             
                        $('#MainContent_resortlist').checkList({
					            listItems: resultCityJson,
					            onChange: selChangeCity
			            });  
                        $('#MainContent_resortlist').checkList('setData', resultCityJson);                     
                    });
            });

            $("#txtDateFrom").datepicker($.datepicker.regional['ru']);
            $("#txtDateTo").datepicker($.datepicker.regional['ru']);
            
            //ConstructCityList
            HideMenuItems();
            $("#hrefMenuTourSearch").addClass('selected');
            $("#divMenuTourSearch").show();

            if ($.query.get("tourTab") != '') {
                HideMenuItems();
                $("#href" + $.query.get("tourTab")).addClass('selected');
                $("#div" + $.query.get("tourTab")).show();
            }
            //$(".three_columns_right").hide();
            $("#headermap").height(90);
            $(".feedflare").hide();
            $("#hrefMenuConstructor").click(function () {
                HideMenuItems();
                $("#hrefMenuConstructor").addClass('selected');
                $("#divMenuConstructor").show();
            });
            $("#hrefMenuReadyTours").click(function () {
                HideMenuItems();
                $("#hrefMenuReadyTours").addClass('selected');
                $("#divMenuReadyTours").show();
            });
            $("#hrefMenuTourSearch").click(function () {
                HideMenuItems();
                $("#hrefMenuTourSearch").addClass('selected');
                $("#divMenuTourSearch").show();
            });
            $("#hrefMenuCorpTours").click(function () {
                HideMenuItems();
                $("#hrefMenuCorpTours").addClass('selected');
                $("#divMenuCorpTours").show();
            });
            $("#hrefMenuExcurs").click(function () {
                HideMenuItems();
                $("#hrefMenuExcurs").addClass('selected');
                $("#divMenuExcurs").show();
            });
            $("#hrefMenuSpecialTours").click(function () {
                HideMenuItems();
                $("#hrefMenuSpecialTours").addClass('selected');
                $("#divMenuSpecialTours").show();
            });
            var cityList = [<%= ViewData["ConstructCityList"] %>];
            $("#MainContent_resortlist").checkList({
					listItems: cityList,
					onChange: selChangeCity
			});
            $("#MainContent_resortlist .checkList .toolbar .chkAllText").html("Все");
        });
        function HideMenuItems() {
            //groups = $('href.pre');
            groups = $('[id^=hrefMenu]');
            $.each(groups, function (key, group) {
                $(group).removeClass('selected');
            });
            groups = $('div.section');
            $.each(groups, function (key, group) {
                $(group).hide();
            });
        }
    </script>
    <div id="menutour" class="ddsmoothmenu-tour">
        <ul>
            <li><a href="#" class="pre" id="hrefMenuTourSearch">Поиск тура</a></li>
            <li><a href="#" class="pre" id="hrefMenuReadyTours">Готовые туры</a></li>
            <%--<li><a href="#" class="pre" id="hrefMenuConstructor">Конструктор туров</a></li>
            <li><a href="#" class="pre" id="hrefMenuSpecialTours">Виды отдыха</a></li>    
            <li><a href="#" class="pre" id="hrefMenuExcurs">Экскурсии</a></li>
            <%--<li><a href="#" class="pre" id="hrefMenuCorpTours">Корпоративные туры</a></li>--%>
        </ul>
    </div>
    <br />
    <%--<span class="mainTitle">
        <h1 class="section" id="sectionTitle">Все туры</h1>
    </span>--%>
    <div style="margin-bottom: 30px; padding-top: 20px;">        
        <div style="margin-top: -20px;" class="section" id="divMenuConstructor">
            <table style="margin:0 auto" id="maintable">
	            <tr>
		            <td id="cell1">
			            <p class="caption">Откуда</p>
			            <select class="sCombo" id="i-city">
                            <option value="1">Санкт-Петербург</option>
                            <option value="2">Москва</option>
                        </select>
		            </td>
		            <td id="cell2">
			            <p class="caption">Куда</p>
			            <select class="sCombo" id="i-country">
                            <%= ViewData["ConstructCountryList"] %>
                        </select>
		            </td>
		            <td id="cell3" colspan="2" style="width:140px">
			            <div class="rangeObject1">
				            <p class="caption">Дата вылета</p>
				            <div id="i-date">
					            с <input type="text" class="tcal tcalChecked" id="txtDateFrom" />
					            по <input type="text" class="tcal tcalRanged" id="txtDateTo" />
				            </div>
			            </div>
		            </td>
		            <td id="cell4" style="vertical-align:middle;width:70px">
                        <div class="rangeObject1">
				            <div class="sCheck threedaycheck"><input id="i-3day" type="checkbox" /><span>±3 дня</span></div>
			            </div>
		            </td>
	            </tr>
	            <tr>
		            <td id="cell5">
			            <p class="caption">Курорт</p>
			            <div>
				            <div id="resortlist" runat="server"></div>
			            </div>
		            </td>
		            <td id="cell6">
			            <p class="caption">Отель</p>
			            <div>
				            <input class="sText" id="i-hoteltxt" type="text">
				            <div class="sCheck wrappedCheck"><input id="i-hotel" type="checkbox" /><span>Любой</span></div>
				            <div id="i-hotellist"></div>
			            </div>
		            </td>
		            <td id="cell7">
			            <div style="padding-right:10px;max-width:70px">
				            <p class="caption">Ночей от</p>
				            <select class="sCombo" id="i-night1"><%= ViewData["ddlNights"] %></select>
				            <div>
					            <p style="margin-top:6px" class="caption">Категория</p>
					            <div class="sCheck"><input id="i-star" type="checkbox" /><span>Любая</span></div>
					            <div id="i-starlist"></div>
				            </div>
			            </div>
		            </td>
		            <td id="cell8">
			            <div>
				            <p class="caption">До</p>
				            <select class="sCombo" id="i-night2" ><%= ViewData["ddlNights"] %></select>
				            <div>
					            <p style="margin-top:6px" class="caption">Питание</p>
					            <div class="sCheck"><input id="i-meal" type="checkbox" /><span>Любое</span></div>
					            <div id="i-meallist"></div>
				            </div>
			            </div>
		            </td>
		            <td id="cell9">
			            <div>
				            <div style="float:left;padding-right:10px">
					            <p class="caption" id="i-adult-caption">Взрослых</p>
					            <select class="sCombo" id="i-adult" style="width:58px"></select>
				            </div>
				            <div>
					            <p class="caption" id="i-kid-caption">Детей</p>
					            <select class="sCombo" id="i-kid" style="width:58px"></select>
				            </div>
			            </div>
			            <div style="padding-top:10px;padding-bottom:20px" id="i-kidages-caption">
				            <p class="caption">Возраст детей</p>
				            <select class="sCombo" id="i-kid1"></select>
				            <select class="sCombo" id="i-kid2"></select>
				            <select class="sCombo" id="i-kid3"></select>
			            </div>
			            <div>
				            <div style="float:left; padding-right:8px">
					            <p class="caption" id="i-price1-caption"><!--Цена от-->Цена за тур</p>
					            <input class="sText" id="i-price1" type="text" />
				            </div>
				            <div>
					            <p class="caption" id="i-price2-caption">до</p>
					            <input class="sText" id="i-price2" type="text" />
				            </div>
			            </div>
			            <div id="i-currency">
				            <span class="sRadio" id="i-curr-1"><input name="i-currency" type="radio" value="RUB" checked="checked" /><span>RUB</span></span>
				            <span class="sRadio" id="i-curr-2"><input name="i-currency" type="radio" value="USD" /><span>USD</span></span>
				            <span class="sRadio" id="i-curr-3"><input name="i-currency" type="radio" value="EUR" /><span>EUR</span></span>
			            </div>
			            <div id="i-flightflag"></div>
			            <div id="btSpawn" style="margin:45px 5px 0 0">
				            <a href="#" target="_blank">Найти тур</a>
			            </div>
		            </td>
	            </tr>
            </table>
                Раздел в разработке.
        </div>    
        <div style="margin-top: -20px;" class="section" id="divMenuReadyTours">
            <div class="special_offers wrapper relover">
		        <div style="width:670px;display:block;margin-left:-30px;">
			        <div class="slider">
                         <%  List<LinqToElcondor.TblTour> offers = ElcondorBiz.BizTour.GetSpecialOfferReadyTourList();
                             List<LinqToElcondor.TblSpecialOffer> offers2 = ElcondorBiz.BizSpecialOffer.GetSpecialOfferReadyToursList();
                            int totalCount = offers2.Count + offers.Count;
                            if (totalCount == 0) {%>
                                <span class="mainTitle">
                                    <h3 style="color:#3b2314;margin-top: 10px;"><u>Готовых туров нет.</u></h3>
                                </span>
                            <% } else {%>
                                <ul class="special_slider_list">
                                <%  StringBuilder sb1 = new StringBuilder();
                                    int cnter = 0;
                                    foreach (LinqToElcondor.TblSpecialOffer item in offers2.ToList()) {
                                        sb1.Append(string.Format("<li><div>"));
                                        sb1.Append(string.Format("<a class=\"special_slider_link\" href=\"{0}\"><figure>", item.LinkUrl));
                                        bool hasImage = false;
                                        try { hasImage = item.Image.Length > 0; } catch { hasImage = false; }
                                        if (hasImage) {
                                            sb1.Append(
                                                string.Format(
                                                "<img src=\"../../Content/UserImages/specialoffer_th_{0}.jpg\"  alt=\"\" width=\"200\" height=\"180\" />", item.Id));
                                        }
                                        sb1.Append(string.Format("<figcaption><b>{1}: </b>{0}</figcaption></figure>", item.Title.Length > 50 ?
                                            item.Title.Substring(0, 50) + "... Подробнее..." : item.Title, ElcondorBiz.BizCountry.GetCountryById(item.CountryId).Name));

                                        sb1.Append(string.Format("<span class=\"slider_price relover\"><span class=\"slider_price_l\"></span>"));
                                        sb1.Append(string.Format("<span class=\"slider_price_c\">{0}</span><span class=\"slider_price_r\"></span>", item.Price.ToString() == "0" ? "Подробнее" : "от " + item.Price.ToString() + "руб."));
                                        sb1.Append("</span></a>");
                                        sb1.Append("</div>");
                                        sb1.Append("</li>");
                                        cnter++;
                                    }
                                    foreach (LinqToElcondor.TblTour item in offers) {
                                        cnter++;
                                        sb1.Append(string.Format("<li><div>"));
                                        sb1.Append(string.Format("<a class=\"special_slider_link\" href=\"../../ViewTour?id={0}\"><figure>", item.Id));
                                        bool hasImage = false;
                                        try { hasImage = item.ThumbImage.Length > 0; } catch { hasImage = false; }
                                        if (hasImage) {
                                            sb1.Append(
                                                string.Format(
                                                "<img src=\"../../Content/UserImages/tour_th_{0}.jpg\"  alt=\"\" width=\"200\" height=\"180\" />", item.Id));
                                        }
                                        string countryName = string.Empty;
										try {
											countryName = ElcondorBiz.BizTour.GetTourCountry(item.Id).Name + ": ";
										} catch {}
										sb1.Append(string.Format("<figcaption><b>{1}</b>{0}</figcaption></figure>", item.Name.Length > 50 ?
                                            item.Name.Substring(0, 50) + "... Подробнее..." : item.Name, countryName));
										
										
                                        sb1.Append(string.Format("<span class=\"slider_price relover\"><span class=\"slider_price_l\"></span>"));
                                        sb1.Append(string.Format("<span class=\"slider_price_c\">{0}</span><span class=\"slider_price_r\"></span>", item.Price.ToString() == "0" ? "Подробнее" : "от " + item.Price.ToString() + "руб."));
                                        sb1.Append("</span></a>");
                                        sb1.Append("</div>");
                                        sb1.Append("</li>");
                                    }
                                    %>
                                    <%= sb1.ToString()%>
                            </ul>   
                            <% } %>  
                    </div>  
                    <%--<button class="next"></button>--%>
                </div> 
                <%--<a href="../../SpecialOffers" class="all_offers">Посмотреть все предложения</a>--%>
	        </div>
        </div> 
        <div style="margin-top: -20px;" class="section" id="divMenuTourSearch">
            <script src="http://ui.sletat.ru/client/linker.js?settings={formViewMode:'block'}&sfx=_2gWN5" type="text/javascript"></script><iframe  id="sm_slySearch_2gWN5" src="http://ui.sletat.ru/SearchForm.html?sfx=_2gWN5&fbg=-1&mbg=ffffff&bbg=ffffff&bbd=eeeeee&cbd=abadb3&c1=222222&c2=838383&c3=333333&c4=-1&style=p.caption%7Bfont-weight%3A%20bold%20!important%3B%7Dp.caption%7Bfont-style%3A%20normal%20!important%3B%7D&tpl=full&dptCity=1264&country=40&settings={}"  style="background:url('http://ui.sletat.ru/gfx/ld3.gif') no-repeat center center;" width="635" height="300" frameborder="0" scrolling="no"></iframe>
<br/>
<input type="button" value="Найти туры" onclick="sm_sly_2gWN5.go()"/>
<br/><br/>
<iframe allowtransparency="true" onload="sm_sly_2gWN5.init()" id="sm_slyResult_2gWN5" src="http://ui.sletat.ru/SearchResult.html?sfx=_2gWN5&fbg=-1&mbg=ffffff&bbg=ffffff&bbd=eeeeee&cbd=abadb3&c1=222222&c2=838383&c3=333333&c4=-1&style=p.caption%7Bfont-weight%3A%20bold%20!important%3B%7Dp.caption%7Bfont-style%3A%20normal%20!important%3B%7D&firstDelay=7000&rc=10&settings={}" height="150" width="635" frameborder="0" style="display:none;" scrolling="no"></iframe>
        </div>       
        <div style="margin-top: -20px;" class="section" id="divMenuExcurs">
            <%--<h3>Экскурсии</h3>--%>
            <%= ViewData["GridList"] %>
        </div>
        <div style="margin-top: -20px;" class="section" id="divMenuCorpTours">
            <%= ViewData["CorpPageContent"] %>
        </div>    
        <div style="margin-top: -20px;" class="section" id="divMenuSpecialTours">
            <%--<h3>Виды туров</h3>--%>
            <% if (ElcondorBiz.BizNews.GetVacationTypeListPresentation().Count > 0) { %>
            <div class="travel_notes relover">
                <div class="wrapper">
                    <div class="g-block g-dotted-v g-clearfix">
		                <div class="b-news-column b-news-column-right">
			                <div class="g-wrap g-clearfix">
                                <%=  ViewData["VacatioTypeListHTML"]%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>           
    </div>
</asp:Content>
