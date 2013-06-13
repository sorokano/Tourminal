<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Rent.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - туристическая компания: Аренда жилья
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">    $(document).ready(function () { initcontrol(); });</script>
    <div id="breadcrumb">
        Аренда жилья
    </div>
    <h1>
        <b>Аренда жилья</b>
    </h1>
    <%--Меню слева--%>
    <div style="width: 300px;float:left;">
        <div id="tarasearch-main">
            Поиск отеля:
            <div id="divSearch">
                <div class=".field-validation-error">
                    <div class="input-validation-error" id="divValidation"></div>
                </div>
                <table id="tblMainSearchPanel">
                    <tr id="101">
                        <td style="width:70px;">
                           Страна:
                        </td>
                        <td>
                            <select id="ddlCountry" style="width: 180px;" class="ui-widget input ui-widget-content ui-widget-header ui-state-default ui-corner-all ui-multiselect"></select>                           
                        </td>
                    </tr>
                    <tr class="spanDistrict">
                        <td>
                            <span >Регион:</span>
                        </td>
                        <td>
                            <span><select id="ddlDistrict" style="width: 180px;" class="ui-widget input ui-widget-content ui-widget-header ui-state-default ui-corner-all ui-multiselect"></select></span>
                        </td>
                    </tr>
                    <tr class="spanCity">
                        <td>
                            <span>Город:</span>
                        </td>
                        <td>
                            <span><select id="ddlCity" style="width: 180px;" class="ui-widget input ui-widget-content ui-widget-header ui-state-default ui-corner-all ui-multiselect"></select></span>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            Тип жилья:
                        </td>
                        <td>
                            <select multiple="multiple" id="ddlAccomodationType" name="ddlAccomodationType" style="width: 100px;"></select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Вид отдыха:
                        </td>
                        <td>
                            <select multiple="multiple" id="ddlGoodForPerson" name="ddlGoodForPerson" style="width: 100px;"></select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Расстояние до моря не более:
                        </td>
                        <td>
                            <select id="ddlDistanceToSea" style="width: 180px;" class="ui-widget input ui-widget-content ui-widget-header ui-state-default ui-corner-all ui-multiselect">
                                <option value="-1">Не имеет значения</option>
                                <option value="100">100 м.</option>
                                <option value="200">200 м.</option>
                                <option value="500">500 м.</option>
                                <option value="1000">1 км.</option>
                                <option value="2000">2 км.</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Цена:
                        </td>
                        <td style="white-space: nowrap">
                             от <input type="text" style="width: 62px;" id="txtPriceStart" />
                            до <input type="text" style="width: 62px;" id="txtPriceEnd" /> руб.
                            <br />
                            <div class="comment">* за номер на двоих в сутки</div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Количество звезд:
                        </td>
                        <td>
                            <form name="api-select" id="formStarRatingChoice">
                                <input name="star1" type="radio" class="star" title="1 звезда" value="1"/>
                                <input name="star1" type="radio" class="star" title="2 звезды" value="2"/>
                                <input name="star1" type="radio" class="star" title="3 звезды" value="3"/>
                                <input name="star1" type="radio" class="star" title="4 звезды" value="4"/>
                                <input name="star1" type="radio" class="star" title="5 звезд" value="5"/>
                                <input type="hidden" id="hdnStarRatingChoice" />
                            </form>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding: 0 !important;margin: 0 !important;">
                             <div id="divAdvancedSearch">
                                <table>
                                    <tr>
                                        <td>Название отеля:</td>
                                        <td style="width: 120px"><input type="text" style="width: 180px;" id="txtHotelName" /></td>
                                        
                                    </tr>
                                    <tr>
                                        <td style="width: 150px"><span>Уникальный номер:</span></td>
                                        <td style="width: 150px"><input type="text" style="width: 50px;" id="txtHotelId" /></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div style="height:100%;float: left; margin-top: 10px; vertical-align: bottom;" id="divAdditionalSearch">
                                <a href="#" id="hrefAdvSearch">Дополнительные параметры поиска</a>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="button" id="btn-search" value="Поиск по указанным параметрам" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>  
    <%--Основной контент--%>
    <div style="width: 580px;padding-left:50px;float:left;">
        Внимание! Система поиска и аренды находится в процессе тестирования. Пожалуйста, воспользуйтесь поиском по адресу: <a href="http://privetgoa.ru">PrivetGoa.ru</a>. Приносим извинения за неудобства. 
        <div id="divResultPanel">
           <div id="divSearchResult"></div>
        </div> 
    </div>

    <div id="dlgViewHotel">
        <div id="hoteltabs">
            <ul>
                <li><a href="#tab-content-main"><span>Основные сведения</span></a></li>
                <li>
                    <a href="#tab-content-gallery"><span id="snapPhotoGalleryText">Фото галерея</span></a>
                </li>
            </ul>
            <div id="tab-content-main">
                <img src="../../Content/images/ajax-wait.gif" />
            </div>
            <div id="tab-content-gallery">
                <img src="../../Content/images/ajax-wait.gif" />
            </div>
        </div>
    </div> 
</asp:Content>
