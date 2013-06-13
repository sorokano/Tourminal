<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактирование города: <%= ViewData["CityName"] %>
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
        }

        function InsertContent() {
            var oEditor = FCKeditorAPI.GetInstance('contentDescr');
            var sample = document.getElementById("sample").value;
            oEditor.InsertHtml(sample);
        }

        function ShowContent() {
            var oEditor = FCKeditorAPI.GetInstance('contentDescr');
            alert(oEditor.GetHTML());
        }

        function ClearContent() {
            var oEditor = FCKeditorAPI.GetInstance('contentDescr');
            oEditor.SetHTML("");
        }

        $(document).ready(function () {
            $("#btncancel").click(function (e) {
                location.href = '/Admin/Index';
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
    <a href="/Admin/Index">Главное меню</a> > <a href="/Admin/CountryEdit?id=<%= ViewData["CountryId"] %>">Редактировать страну <%= ViewData["CountryName"] %></a> > <a href="/Admin/RegionEdit?id=<%= ViewData["RegionId"] %>"> Редактировать регион <%= ViewData["RegionName"] %></a>
    <h2>Редактирование города: <%= ViewData["CityName"] %></h2>
    <a href="../../Admin/CountryListEdit" style="color:#0000ff">Добавить/удалить/ред. название города</a>
    <%= Html.ValidationSummary("Не удалось сохранить. Проверьте данные и попробуйте снова.") %>
    <% using (Html.BeginForm("CityEdit", "Admin", FormMethod.Post)) { %>
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
                <%= Html.TextBox("txtCityId", ViewData["CityId"], new { style = "visibility:hidden; width:50px" })%>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <table><tr><td>ЛОКАЦИЯ-ПЛЯЖ:</td><td><%= Html.CheckBox("isBeach", bool.Parse(ViewData["IsBeach"].ToString()))%></td></tr></table>
            </td>
        </tr>        
        <tr>
            <td>
                <table>
                    <tr><td>Общая информация: </td></tr>
                    <tr><td><%= Html.TextArea("contentDescr", ViewData["Description"] == null ? string.Empty : ViewData["Description"].ToString(), 3, 1, new { style = "width:450px", name = "contentDescr" })%></td></tr>
                </table>
            </td>
        </tr>
    </table>
    <p>
        <input type="submit" value="Сохранить" />
        <input type="button" value="Отмена" id="btncancel" />
    </p> 
    <% } %>
    <div style="width: 400px;" id="divPhotoArea">
        <a href="/Admin/EditCityPhoto?id=<%= ViewData["CityId"].ToString() %>">Редактировать фото</a> (<%= ViewData["ImgUploadCount"] %> загружено)
    </div>
    <br /><br />
    <a href="/Admin/Index">Главное меню</a> > <a href="/Admin/CountryEdit?id=<%= ViewData["CountryId"] %>">Редактировать страну <%= ViewData["CountryName"] %></a>  > <a href="/Admin/RegionEdit?id=<%= ViewData["RegionId"] %>"> Редактировать регион <%= ViewData["RegionName"] %></a>
</asp:Content>
