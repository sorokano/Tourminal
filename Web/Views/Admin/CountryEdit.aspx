<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактирование страны: <%=ViewData["CountryName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#hrefAddItem").click(function (e) {
                $('#txtItemId').val("null");
                $('#txtItemValue').val("");
                $('#txtItemType').val("<%= ViewData["DictionaryItemType"] %>");
                $("#hrefRegionEdit").hide();
                $('#dialog-addcountryinfo').dialog('open');
            });
            
            $("#dialog-addcountryinfo").dialog({
                autoOpen: false,
                height: 500,
                width: 700,
                modal: true,
                buttons: {
                    'Закрыть': function () {
                        $(this).dialog('close');
                        return false;
                    }
                },
                close: function () {
                    $('#txtItemId').val("");
                    $('#txtItemValue').val("");
                    location.reload();
                }
            });

            $(".img-edit").click(function (e) {
                location.href = "../../Admin/CountryInfoEdit?id=" + $(this).attr("id");
            });

            $(".img-delete").click(function (e) {
                if (confirm("Удалить главу? Внимание! Отмена этого действия невозможна.")) {
                    var itemIdImgAlt = $(this).attr("alt");
                    var itemId = itemIdImgAlt.substring(8, itemIdImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/DeleteDictionaryItem",
                        data: "parameters=" + itemId + "|" + "<%= ViewData["DictionaryItemType"] %>",
                        success: function (msg) {
                            if (msg == '"error"') {
                                msg = msg + " - произошла ошибка. Попробуйте снова.";
                            }
                            location.reload();
                        }
                    });
                }
            });

        });

        window.onload = function () {
            /*var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor = new FCKeditor('contentAdditional');
            oFCKeditor.Config.Enabled = true;
            oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';
            oFCKeditor.ToolbarSet = 'DefaultNoSave';

            oFCKeditor.Height = '400';
            oFCKeditor.Width = '600';
            oFCKeditor.BasePath = sBasePath;
            oFCKeditor.ReplaceTextarea();//contentAdditional

            var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor = new FCKeditor('contentVisa');
            oFCKeditor.Config.Enabled = true;
            oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';
            oFCKeditor.ToolbarSet = 'DefaultNoSave';

            oFCKeditor.Height = '400';
            oFCKeditor.Width = '600';
            oFCKeditor.BasePath = sBasePath;
            oFCKeditor.ReplaceTextarea();*/
        }

        $(document).ready(function () {
            $("#btncancel").click(function (e) {
                location.href = '../../Admin/Index';
            });

            $("#hrefAssignCapital").click(function (e) {
                $("#dialog-assigncapital").dialog('open');
            });

            $("#dialog-assigncapital").dialog({
                autoOpen: false,
                height: 300,
                width: 400,
                modal: true,
                buttons: {
                    'Закрыть': function () {
                        $(this).dialog('close');
                    }
                },
                close: function () { }
            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a>
    <h2>Редактирование страны: <%=ViewData["CountryName"] %></h2>
    <div style="width: 500px;float: right;margin: -110px 150px 0 500px;">
        <div style="float: left;">
            <fieldset>
                <table style="vertical-align: top; width: 100%; white-space: nowrap; font-weight: bold;">
                    <tr>
                        <td colspan="4">
                            <% using (Html.BeginForm("UploadCountryFlagImg", "Admin", FormMethod.Post, new { enctype = "multipart/form-data", })) {%>
                                Загрузить картинку флага (Ш120 X В80):<br />
                                <input type="file" id="fileUpload" name="fileUpload" size="23"/>
                                <input type="submit" value="Загрузить" />
                                <input type="text" visible="false" style="display: none;" id="txtCountryId" name="txtCountryId" value="<%= ViewData["CountryId"] %>" />
                            <% } %>      
                        </td>
                    </tr>
                </table> 
            </fieldset> 
        </div>
        <div style="float: right;margin: 20px 0 0 15px;">
            <% if (ElcondorBiz.BizCountry.GetImage(int.Parse(ViewData["CountryId"].ToString())) != null) { %>
                <img src="/Content/UserImages/flag_<%=ViewData["CountryId"].ToString()%>.jpg" alt="" style="height: 60px;" />
            <% } %> 
        </div>
    </div>
    <table>
        <tr><td>Главы содержания статьи "О стране":</td></tr>
        <tr>
            <td>
                <br />
                <img src="../../Content/images/grid-add.png" alt="" /><a href="#" id="hrefAddItem">Добавить</a>
                <br />
                <%= ViewData["GridCountryInfoList"]%>
            </td>
        </tr>
    </table>
    <%= Html.ValidationSummary("Не удалось сохранить. Проверьте данные и попробуйте снова.") %>
    <% using (Html.BeginForm("CountryEdit", "Admin", FormMethod.Post)) { %>
    <table>
        <tr>
            <td valign="top">
               <!-- <table>
                    <tr><td>Здоровье и безопасность:</td></tr>
                    <tr><td>--><%= Html.TextArea("contentAdditional", ViewData["AdditionalInfo"] == null ? string.Empty : ViewData["AdditionalInfo"].ToString(), 3, 1, new { style = "width:500px;visibility:hidden;", name = "contentAdditional" })%><!--</td></tr>
                </table>-->
            </td>
            <td>
               <!-- <table>
                    <tr><td>Информация о визе и пребывании:</td></tr>
                    <tr><td>--><%= Html.TextArea("contentVisa", ViewData["VisaDescription"] == null ? string.Empty : ViewData["VisaDescription"].ToString(), 3, 1, new { style = "width:500px;visibility:hidden;", name = "contentVisa" })%><!--</td></tr>
                </table>-->
            </td>
        </tr>
    </table><!--
    <p>
        <input type="submit" value="Сохранить" />
        <input type="button" value="Отмена" id="btncancel" />
    </p>--> <%= Html.TextBox("txtCountryId", ViewData["CountryId"], new { style = "visibility:hidden; width:50px" })%>
    <% } %>
    <div id="divRegionCityList">
        <h3>Регионы и города (<a href="../../Admin/CountryListEdit" style="color:#0000ff">Добавить/удалить/ред. название страны, регионы, города</a>):</h3>
        <%  StringBuilder sb1 = new StringBuilder();
            int i = 0;
            sb1.Append("<ul style=\"margin: -10px 0 8px -35px !important;\">");
            LinqToElcondor.TblCity capital = ElcondorBiz.BizCity.GetCapitalCity(int.Parse(ViewData["CountryId"].ToString()));
                if (capital != null) {
                    LinqToElcondor.TblRegion capregn = ElcondorBiz.BizRegion.GetRegionById(capital.RegionId);
                    sb1.Append(string.Format(
    "<li style=\"padding-left: 3px;display: inline;float: left;\">&#x2022; Столица: <a href=\"../../Admin/CityEdit?id={0}\" id=\"cty{0}\"><b>{1}</b> </a></li>"
                        , capital.Id, capital.Name.ToUpper()));
                }
            foreach (LinqToElcondor.TblRegion regn in Elcondor.UI.Utilities.DictionaryHelper.GetDistrictListData(int.Parse(ViewData["CountryId"].ToString()))) {
                if (capital == null || regn.Id != capital.RegionId) {
                    sb1.Append(string.Format(
                        "<li style=\"padding-left: 3px;display: inline;float: left;position: relative;font-weight:bolder;\">{2}<a href=\"../../Admin/RegionEdit?id={0}\" id=\"regn{0}\" style=\"text-decoration: none;\">{1} <span class=\"dc-icon\"></span></a> : </li>"
                        , regn.Id, regn.Name.ToUpper(), "&nbsp;&nbsp; &#x2022; "));
                    i++;
                    sb1.Append("<ul style=\"display: inline;margin-bottom: 0 !important;\">");
                   foreach (LinqToElcondor.TblCity cty in Elcondor.UI.Utilities.DictionaryHelper.GetCityListData(regn.Id)) {
                       sb1.Append(string.Format("<li style=\"padding-left: 3px;display: inline;float: left;\">&#x25E6; <a href=\"../../Admin/CityEdit?id={0}\" id=\"cty{0}\">{1} [{2},{3}] <span class=\"dc-icon\"></span></a></li>", cty.Id, cty.Name, cty.Latitude, cty.Longitude));
                   }
               }
               sb1.Append("</ul>");     
           }
           sb1.Append("</ul>");
        %>
        <%= sb1.ToString() %>
    </div>
    <br /><br />
    <b>СТОЛИЦА: </b><%= ViewData["CountryCapitalName"] == null ? "СТОЛИЦА НЕ НАЗНАЧЕНА." : ViewData["CountryCapitalName"]%>
    <a href="#" id="hrefAssignCapital">Назначить столицу</a>
    <br /><br />
    <a href="../../Admin/Index">Главное меню</a>
    <div id="dialog-assigncapital">
        <% using (Html.BeginForm("CityAssignCapital", "Admin", FormMethod.Post, new { autocomplete = "off" })) { %>
            <table><tr><td>Город:</td></tr><tr><td><%= Html.DropDownList("ddlCity", (IEnumerable<SelectListItem>)ViewData["ddlCity"])%> </td></tr></table>
            <input type="submit" value="Назначить столицу" id="btnSave" name="btnEditItem" value="edititem" />
        <% } %>
    </div>
    <div id="dialog-addcountryinfo">
        <h2>Добавить главу в статью "О стране" <%=ViewData["CountryName"] %></h2>
        <% using (Html.BeginForm("EditDictionaryItem", "Admin", FormMethod.Post, new { autocomplete = "off" })) { %>
            <%= Html.TextBox("txtItemValue", string.Empty, new { style = "width:500px" })%>
            <%= Html.TextBox("txtParentItemId", ViewData["CountryId"], new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtItemType", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <input type="submit" value="Сохранить" id="Submit1" name="btnEditItem" value="edititem" />
        <% } %>
        <br />
        <a href="../../Admin/RegionListEdit?countryId=" id="hrefRegionEdit">
            <img style="vertical-align:middle" src="../../Content/images/grid-edit.gif"> Список регионов страны
        </a>
    </div>
</asp:Content>
