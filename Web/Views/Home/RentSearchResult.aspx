<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Rent.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - туристическая компания: Поиск отелей: Результаты поиска
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#divValidation").hide();
            $(".country_maininfo").css("padding", "0");
            $("#tara_txtPriceMin").val($.query.get("priceMin"));
            $("#tara_txtPriceMax").val($.query.get("priceMax"));

            $("#tara_txtPriceMin").change(function (e) {
                $(":input").attr("disabled", "disabled");
                var newQuery = $.query.set("priceMin", $(this).val()).toString();
                newQuery = newQuery.replace("pageNumber=", "");
                document.location = ((document.location.toString()).split('?'))[0] + newQuery;
            });
            $("#tara_txtPriceMax").change(function (e) {
                $(":input").attr("disabled", "disabled");
                var newQuery = $.query.set("priceMax", $(this).val()).toString();
                newQuery = newQuery.replace("pageNumber=", "");
                document.location = ((document.location.toString()).split('?'))[0] + newQuery;
            });
            $("#btn-clearall").click(function (e) {

            });
            $(".star-rating a").click(function (e) {
                $(":input").attr("disabled", "disabled");
                var newQuery = $.query.set("starRating", $(this).attr("title")).toString();
                newQuery = newQuery.replace("pageNumber=", "");
                document.location = ((document.location.toString()).split('?'))[0] + newQuery;
            });
        });
        </script>
    <%--<div id="breadcrumb">
        Поиск отелей
    </div>--%>
    <span style="font-size: 28px;width:100%;display: block;">
        <a class="btnpink" style="font-weight:bold;" href="/RentList?countryName=<%= ViewData["CountryNames"]%>&datefrom=<%= ViewData["DateFrom"] %>&dateto=<%= ViewData["DateTo"] %>&adults=<%= ViewData["Adults"] %>&kids=<%= ViewData["Kids"] %>">Вернуться к поиску отеля<%--изменить условия поиска--%></a>
        <br />
        <% string cityNames = ViewData["CityNames"].ToString() == "?" ? string.Empty : "(" + ViewData["CityNames"].ToString() + ")";
           string regionNames = ViewData["RegionNames"].ToString() == "?" ? string.Empty : "(" + ViewData["RegionNames"].ToString() + ")"; %>
        Найдено отелей:  <%= ViewData["NumberResults"] %>, <%= ViewData["CountryNames"]%> 
        <% if (!string.IsNullOrEmpty(ViewData["CityNames"].ToString())) { %>
            <%= cityNames %>
        <% } else if (!string.IsNullOrEmpty(ViewData["RegionNames"].ToString())) { %>
            <%= regionNames %>
        <% } %>
        
    </span>
    <span style="width:100%;display: block;font-size:14px;">
        Взрослых: <%= ViewData["Adults"] %>, детей: <%= ViewData["Kids"] %>, с <%= ViewData["DateFrom"] %> по <%= ViewData["DateTo"]%> 
        
        <span style="float:right">Сортировать по <a href="#" id="btnsortpopular" class="topmenuitem">популярности</a> <a href="#" id="btnsortprice" class="topmenuitem">цене</a></span>
    </span>
    <%--Меню слева--%>
    <%= Html.ValidationSummary("")%>
        <div id="navLeft">
            <div id="fragment-1">
                <!-- RENT BLUE PANEL START -->                    
                <% using (Html.BeginForm()) { %>
                <div class="bluepanel">
                    <div id="tarasearch-main">
                        <div id="divSearch">
                            <div class=".field-validation-error">
                                <div class="input-validation-error" id="divValidation"></div>
                            </div>
                            <table class="tblMainSearchPanel">
                                <tr>
                                    <td colspan="2">
                                        <span><b>Цена 1 ночь:</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="white-space: nowrap" colspan="2">
                                            от <input type="text" style="width: 60px;" id="tara_txtPriceMin" />
                                        до <input type="text" style="width: 60px;" id="tara_txtPriceMax" /> <span style="color:#b1b4b6">руб.</span>
                                        <br />
                                        <%--<div class="comment">* for a double bed room per night</div>--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Количество звезд:</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <form name="api-select" id="form1">
                                            <input name="star1" type="radio" class="star" title="1 звезда" value="1"/>
                                            <input name="star1" type="radio" class="star" title="2 звезды" value="2"/>
                                            <input name="star1" type="radio" class="star" title="3 звезды" value="3"/>
                                            <input name="star1" type="radio" class="star" title="4 звезды" value="4"/>
                                            <input name="star1" type="radio" class="star" title="5 звезд" value="5"/>
                                            <input type="hidden" id="Hidden1" />
                                        </form>
                                    </td>
                                </tr>
                                <tr>
                                    <td><hr /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Расположение:</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <select id="tara_ddlDistanceToSea" style="width: 150px;" class="ui-widget input ui-widget-content ui-widget-header ui-state-default ui-corner-all ui-multiselect">
                                            <option value="-1">(Нет предпочтений)</option>
                                            <option value="100">100 м</option>
                                            <option value="200">200 м</option>
                                            <option value="500">500 м</option>
                                            <option value="1000">1 км</option>
                                            <option value="2000">> 2 км</option>
                                        </select> до моря
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Гугл карта
                                    </td>
                                </tr>
                                <tr>
                                    <td><hr /></td>
                                </tr>
                                <tr>
                                    <td><b>Дополнительно в отеле:</b></td>
                                </tr>
                                <tr>
                                    <td>
                                        <ul class="checkbox-list">
                                        <% StringBuilder sb = new StringBuilder();
                                            foreach (TaratripLinq.TblHotelAmenity gf in TaratripBiz.BizHotel.GetHotelAmenityList()) {
                                                sb.Append(string.Format("<li><input type=\"checkbox\" id=\"tara_chkAM{0}\" value=\"{0}\" /><label>{1}</label></li>", gf.Id, gf.Description));
                                            }
                                            %>
                                            <%= sb.ToString() %>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Услуги отеля:</b></td>
                                </tr>
                                <tr>
                                    <td>
                                        <ul class="checkbox-list">
                                        <% sb = new StringBuilder();
                                        foreach (TaratripLinq.TblHotelService gf in TaratripBiz.BizHotel.GetHotelServicesList()) {
                                            sb.Append(string.Format("<li><input type=\"checkbox\" id=\"tara_chkSR{0}\" value=\"{0}\" /><label>{1}</label></li>", gf.Id, gf.Description));
                                       }
                                        %>
                                        <%= sb.ToString() %>
                                    </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="text" style="margin-top:5px;width: 200px;height:20px !important;font-size:14px;color:#b1b4b6;" id="txtHotelName" value="Название отеля"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div style="position:relative;margin: 0 auto;text-align:center;padding: 0;">
                                            <a class="yellow_button_s"  id="btn-clearall">
                                                <strong>Сбросить фильтры</strong>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>                           
            <!--END RENT PANEL-->
        </div>
        <% } %>
        <%--Основной контент--%>
        <div style="width: 470px;padding-left:5px;float:left;">
        <h1></h1>
            <div id="divResultPanel">
               <div id="divSearchResult">
                    <%=  ViewData["SearchResultsGrid"]%>
                    
               </div>
            </div> 
        </div>
</asp:Content>
