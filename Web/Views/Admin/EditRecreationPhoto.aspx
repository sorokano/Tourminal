<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактирование фото достопримечательности: <%= ViewData["RecreationName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            UpdateRecreationImages();
            
            var auth = "<% = Request.Cookies[FormsAuthentication.FormsCookieName]==null ? string.Empty : Request.Cookies[FormsAuthentication.FormsCookieName].Value %>";
            var ASPSESSID = "<%= Session.SessionID %>";

            $('#file_upload').uploadify({
                'uploader': '../../Scripts/uploadify/uploadify.swf',
                'script': '<%= Url.Action("UploadRecreationImages", "Admin") %>',
                'cancelImg': '../../Scripts/uploadify/cancel.png',
                'folder': '../../Content/UserImages',
                'auto': true,
                'fileExt': '*.jpg;*.gif;*.png',
                'fileDesc': 'Изображения',
                'multi': true,
                'auto': false,
                'buttonText': 'Browse...',
                'scriptData': { ASPSESSID: ASPSESSID, AUTHID: auth },
                'onSelectOnce': function (event, data) { },
                'onComplete': function (event, ID, fileObj, response, data) {
                    response = $.parseJSON(response);
                    if (response.Status == 'OK') {
                        $("#divStatus").html('Файл был успешно загружен');
                        UpdateRecreationImages();
                    }
                }
            });
        });

        function OnDeleteRecreationImage(recreationImageId) {
            if (confirm("Удалить фото?")) {
                $.ajax({
                    type: "POST",
                    url: "/Admin/DeleteRecreationImage",
                    data: "recreationImageId=" + recreationImageId,
                    success: function(msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                        }
                        location.reload();
                    }
                });
            }
        }
        
        function UpdateRecreationImages() {
            $.ajax({
                type: "POST",
                url: "/Admin/GetRecreationImagesHTML",
                data: "id=" + <%= Session["RecreationId"].ToString() %>,
                success: function (data) {
                    $("#divRecreationImg").html(data);
                }
            });
        }
    </script>
    <input type="hidden" id="hdnId" value="<%= ViewData["Id"] %>" />
    <a href="/Admin/Index">Главное меню</a> > <a href="/Admin/RecreationList">Список статей</a> > <a href="/Admin/AddRecreation?id=<%= ViewData["Id"] %>">Редактировать статью <%= ViewData["RecreationName"]%></a>
    <br />
    <table>
    <h2>Редактирование фото достопримечательности: <%= ViewData["RecreationName"] %></h2>
    <table>
        <tr valign="top">
            <td style="width: 450px;">
                <div style="width: 350px;">
                    <fieldset>
                        <h2>Фото галерея статьи</h2>
                        <span class="comment">Внимание! Фото не должны превышать 5Мб. Все фото будут уменьшены до 450px.</span>
                        <br /><br />
                        <table style="vertical-align: top; width: 100%; white-space: nowrap; font-weight: bold;">
                            <tr>
                                <td colspan="4">
                                  1. Выберите фото: <input type="file" id="file_upload" name="file_upload" /><br />
                                  2. <a href="javascript:$('#file_upload').uploadifyUpload();">Загрузить выбранные фото</a>
                                  <div id="divStatus"></div>
                                </td>
                            </tr>
                        </table> 
                    </fieldset> 
                </div>
               
            </td>
            <td>
                <h2>Загруженные фото</h2>
                <div style="width: 500px;" id="divRecreationImg"></div>        
            </td>
        </tr>
    </table>
    <a href="/Admin/Index">Главное меню</a> > <a href="/Admin/RecreationList">Список статей</a> > <a href="/Admin/AddRecreation?id=<%= ViewData["Id"] %>">Редактировать статью <%= ViewData["RecreationName"]%></a> 
</asp:Content>