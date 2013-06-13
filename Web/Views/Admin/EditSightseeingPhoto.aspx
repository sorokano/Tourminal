<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактирование фото статьи: <%= ViewData["SightseeingName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            UpdateSightseeingImages();
            
            var auth = "<% = Request.Cookies[FormsAuthentication.FormsCookieName]==null ? string.Empty : Request.Cookies[FormsAuthentication.FormsCookieName].Value %>";
            var ASPSESSID = "<%= Session.SessionID %>";

            $('#file_upload').uploadify({
                'uploader': '../../Scripts/uploadify/uploadify.swf',
                'script': '<%= Url.Action("UploadSightseeingImages", "Admin") %>',
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
                        UpdateSightseeingImages();
                    }
                }
            });
        });

        function OnDeleteSightseeingImage(sightseeingImageId) {
            if (confirm("Удалить фото?")) {
                $.ajax({
                    type: "POST",
                    url: "/Admin/DeleteSightseeingImage",
                    data: "sightseeingImageId=" + sightseeingImageId,
                    success: function(msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                        }
                        location.reload();
                    }
                });
            }
        }

        function OnDeleteSightseeingThumbImage(sightseeingImageId) {
            if (confirm("Удалить фото?")) {
                $.ajax({
                    type: "POST",
                    url: "/Admin/DeleteSightseeingThumbImage",
                    data: "sightseeingImageId=" + sightseeingImageId,
                    success: function(msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                        }
                        location.reload();
                    }
                });
            }
        }

        function UpdateSightseeingImages() {
            $.ajax({
                type: "POST",
                url: "/Admin/GetSightseeingImagesHTML",
                data: "id=" + <%= Session["SightseeingId"].ToString() %>,
                success: function (data) {
                    $("#divSightseeingImg").html(data);
                }
            });
        }
    </script>
    <input type="hidden" id="hdnId" value="<%= ViewData["Id"] %>" />
    <a href="/Admin/Index">Главное меню</a> > <a href="/Admin/SightseeingList">Список статей</a> > <a href="/Admin/AddSightseeing?id=<%= ViewData["Id"] %>">Редактировать статью <%= ViewData["SightseeingName"]%></a>
    <br />
    <table>
    <h2>Редактирование фото статьи: <%= ViewData["SightseeingName"] %></h2>
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
                <div style="width: 300px;">
                    <fieldset>
                        <h2>Загрузить основную картинку(W215xH122)</h2>
                        <table style="vertical-align: top; width: 100%; white-space: nowrap; font-weight: bold;">
                            <tr>
                                <td colspan="4">
                                    <% using (Html.BeginForm("UploadImg", "Admin", FormMethod.Post, new { enctype = "multipart/form-data", }))
                                    {%>
                                            Загрузить картинку:<br />
                                            <input type="file" id="fileUpload" name="fileUpload" size="23"/>
                                            <input type="submit" value="Загрузить" />
                                 
                                            <input type="text" visible="false" style="display: none;" id="txtSightseeingId" name="txtSightseeingId" value="<%= ViewData["Id"] %>" />
                                        <% } %>      
                                </td>
                            </tr>
                        </table> 
                        <div style="float: left; position: relative;">
                        <% if (Session["ImageUploaded"] != null) { %>
                            <img src="../../Content/UserImages/sightseeing_th_<%= ViewData["Id"] %>.jpg" alt="" />
                            <a href="#" id="imgDelete<%= ViewData["Id"] %>" onclick="return OnDeleteSightseeingThumbImage(<%= ViewData["Id"] %>);">Удалить фото [X]</a>
                        <% } %>
                        </div>
                    </fieldset> 
                </div>
            </td>
            <td>
                <h2>Загруженные фото</h2>
                <div style="width: 500px;" id="divSightseeingImg"></div>        
            </td>
        </tr>
    </table>
    <a href="/Admin/Index">Главное меню</a> > <a href="/Admin/SightseeingList">Список статей</a> > <a href="/Admin/AddSightseeing?id=<%= ViewData["Id"] %>">Редактировать статью <%= ViewData["SightseeingName"]%></a> 
</asp:Content>