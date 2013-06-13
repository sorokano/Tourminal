<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактирование региона: <%= ViewData["RegionName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor = new FCKeditor('contentDescr');
            oFCKeditor.Config.Enabled = true;
            oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';
            oFCKeditor.ToolbarSet = 'DefaultNoSave';

            oFCKeditor.Height = '400';
            oFCKeditor.Width = '750';
            oFCKeditor.BasePath = sBasePath;
            oFCKeditor.ReplaceTextarea();

            var oFCKeditor2 = new FCKeditor('txtDlgItemDescription');
            oFCKeditor2.Config.Enabled = true;
            oFCKeditor2.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor2.Config.UserFilesAbsolutePath = '/Content/UserImages';
            oFCKeditor2.ToolbarSet = 'DefaultNoSave';

            oFCKeditor2.Height = '400';
            oFCKeditor2.Width = '750';
            oFCKeditor2.BasePath = sBasePath;
            oFCKeditor2.ReplaceTextarea();
        }

        $(document).ready(function () {
            //$.each(["layerX","layerY"], function(i,v) { if((i=p.indexOf(v)) > -1) $.fn.splice.call($.event.props,i,1) });

            $("#hrefAddItem").click(function (e) {
                $('#txtDlgItemId').val("null");
                $('#txtDlgItemName').val("");
                $('#txtDlgItemOrder').val("");
                $('#txtDlgRegionId').val("<%= ViewData["RegionId"] %>");
                var oEditor = FCKeditorAPI.GetInstance('txtDlgItemDescription');
                oEditor.SetHTML("");
                $('#dialog-edititem').dialog('open');
            });

            $(".img-edit").click(function (e) {
                var itemId = $(this).attr("id");
                var itemValue = $(this).attr("name");
                var oEditor = FCKeditorAPI.GetInstance('txtDlgItemDescription');
                oEditor.SetHTML("");
                $.getJSON("http://tourminal.ru/ElcondorWCF.svc/GetRegionRecreationDescr" + "?method=?&regionRecreationId=" + itemId, function (response) {
                    $('#txtDlgItemName').val(itemValue);
                    $('#txtDlgItemId').val(itemId);
                    oEditor.SetHTML(response);
                    $.getJSON("http://tourminal.ru/ElcondorWCF.svc/GetRegionRecreationItemOrder" + "?method=?&regionRecreationId=" + itemId, function (response2) {
                        $('#txtDlgItemOrder').val(response2);
                    });
                    $('#txtDlgRegionId').val("<%= ViewData["RegionId"] %>");
                    $("#hrefEditPhoto").attr("href", "/Admin/EditRecreationPhoto?id=" + itemId);
                    $('#dialog-edititem').dialog('open');
                });
            });

            $(".img-delete").click(function (e) {
                if (confirm("Удалить? Внимание! Все объекты, связанные с этим будут удалены!")) {
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

            $("#dialog-edititem").dialog({
                autoOpen: false,
                height: 600,
                width: 800,
                modal: true,
                buttons: {
                    'Закрыть': function () {
                        $(this).dialog('close');
                    }
                },
                close: function () {
                    $('#txtDlgItemId').val("");
                    $('#txtDlgItemDescription').val("");
                    location.reload();
                }
            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../Admin/CountryEdit?id=<%= ViewData["CountryId"] %>">Редактировать страну <%= ViewData["CountryName"] %></a> 
    <h2>Редактирование региона: <%= ViewData["RegionName"] %></h2>
    <% using (Html.BeginForm("RegionEdit", "Admin", FormMethod.Post)) { %>
    <table>
        <tr>
            <td>
                <table>
                    <tr>    
                        <td>
                            Координаты города на карте (можно узнать на сайте <a href="http://itouchmap.com/latlong.html" target="_blank">http://itouchmap.com/latlong.html</a>):
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Latitude(долгота): <%= Html.TextBox("txtLatitude", ViewData["Latitude"] == null ? string.Empty : ViewData["Latitude"].ToString(), new { style = "width:100px" })%>
                            Longitude(широта): <%= Html.TextBox("txtLongitude", ViewData["Longitude"] == null ? string.Empty : ViewData["Longitude"].ToString(), new { style = "width:100px" })%>
                        </td>
                    </tr>
                </table>
                <table>
                    <tr><td>Общая информация:<%= Html.TextBox("txtRegionId", ViewData["RegionId"], new { style = "visibility:hidden; width:50px" })%> </td></tr>
                    <tr><td><%= Html.TextArea("contentDescr", ViewData["Description"] == null ? string.Empty : ViewData["Description"].ToString(), 3, 1, new { style = "width:450px", name = "contentDescr" })%></td></tr>
                </table>
            </td>
            <td valign="top">
                <h3>Города этого региона (<a href="../../Admin/CountryListEdit" style="color:#0000ff">Добавить/удалить/ред. название страны, регионы, города</a>):</h3>
                <%  StringBuilder sb1 = new StringBuilder();
                    int i = 0;
                       sb1.Append("<ul style=\"display: inline;margin-bottom: 0 !important;\">");
                       foreach (LinqToElcondor.TblCity cty in Elcondor.UI.Utilities.DictionaryHelper.GetCityListData(int.Parse(ViewData["RegionId"].ToString()))) {
                           sb1.Append(string.Format("<li style=\"padding-left: 3px;display: inline;float: left;\">&#x25E6; <a href=\"../../Admin/CityEdit?id={0}\" id=\"cty{0}\">{1} [{2},{3}] <span class=\"dc-icon\"></span></a></li>", cty.Id, cty.Name, cty.Latitude, cty.Longitude));
                       }
                       sb1.Append("</ul>");     
                %>
                <%= sb1.ToString() %>
                <br />
                <h3>Пляжи этого региона :</h3>
                <%  sb1 = new StringBuilder();
                    i = 0;
                       sb1.Append("<ul style=\"display: inline;margin-bottom: 0 !important;\">");
                       foreach (LinqToElcondor.TblCity cty in Elcondor.UI.Utilities.DictionaryHelper.GetBeachListData(int.Parse(ViewData["RegionId"].ToString()))) {
                           sb1.Append(string.Format("<li style=\"padding-left: 3px;display: inline;float: left;\">&#x25E6; <a href=\"../../Admin/CityEdit?id={0}\" id=\"cty{0}\">{1} [{2},{3}] <span class=\"dc-icon\"></span></a></li>", cty.Id, cty.Name, cty.Latitude, cty.Longitude));
                       }
                       sb1.Append("</ul>");     
                %>
                <%= sb1.ToString() %>
            </td>
        </tr>
    </table>
    <p>
        <input type="submit" value="Сохранить" />
        <input type="button" value="Отмена" id="btncancel" />
    </p> 
    <% } %>
    <br />
    <h2>Достопримечательности региона <span style="font-size:12px;color:#333333">(Будут представлены пунктами в верхнем выпадающем меню на страницах описания страны)</span>:</h2>
    <img src="../../Content/images/grid-add.png" alt="" /><a href="#" id="hrefAddItem">Добавить</a>
    <br />
    <%= ViewData["GridRegionRecreation"] %>
    <br /><br />
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../Admin/CountryEdit?id=<%= ViewData["CountryId"] %>">Редактировать страну <%= ViewData["CountryName"] %></a> 
    <div id="dialog-edititem">
        <% using (Html.BeginForm("EditRecreationItem", "Admin", FormMethod.Post, new { autocomplete = "off" })) { %>
            Описание достопримечательности:<br />
            <%= Html.TextBox("txtDlgItemName", string.Empty, new { style = "width:250px" })%>
            &nbsp;Порядковый номер: <%= Html.TextBox("txtDlgItemOrder", string.Empty, new { style = "width:150px" })%>
            <%= Html.TextArea("txtDlgItemDescription", string.Empty, 3, 1, new { name = "txtItemDescription" })%>
            <%= Html.TextBox("txtDlgItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtDlgRegionId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <input type="submit" value="Сохранить" id="btnSave" name="btnEditItem" value="edititem" />
        <% } %>
        <a id="hrefEditPhoto">Редактировать фото галерею(доступно после создания Достопримечательности)</a>
    </div>
</asp:Content>
