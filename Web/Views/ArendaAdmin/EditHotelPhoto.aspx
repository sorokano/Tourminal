<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Редактирование фото отеля
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            UpdateHotelImages();
            
            var auth = "<% = Request.Cookies[FormsAuthentication.FormsCookieName]==null ? string.Empty : Request.Cookies[FormsAuthentication.FormsCookieName].Value %>";
            var ASPSESSID = "<%= Session.SessionID %>";

            $('#file_upload').uploadify({
                'uploader': '../../Scripts/uploadify/uploadify.swf',
                'script': '<%= Url.Action("UploadImages", "ArendaAdmin") %>',
                'cancelImg': '../../Scripts/uploadify/cancel.png',
                'folder': '../../Content/images/HotelImages',
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
                        UpdateHotelImages();
                    }
                }
            });
        });

        function OnDeleteHotelImage(hotelImageId) {
            if (confirm("Удалить фото?")) {
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/DeleteHotelImage",
                    data: "hotelImageId=" + hotelImageId,
                    success: function(msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                        }
                        location.reload();
                    }
                });
            }
        }

        function RemoveHotelThumbImage(hotelId) {
            if (confirm("Удалить фото?")) {
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/RemoveHotelThumbImage",
                    data: "hotelId=" + hotelId,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                        }
                        location.reload();
                    }
                });
            }
        }

        function UpdateHotelImages() {
            $.ajax({
                type: "POST",
                url: "/ArendaAdmin/GetHotelImagesHTML",
                data: "hotelId=" + <%= Session["HotelId"].ToString() %>,
                success: function (data) {
                    $("#divHotelImg").html(data);
                }
            });
        }
    </script>
    <input type="hidden" id="hdnHotelId" value="<%= ViewData["HotelId"] %>" />
    <a href="/ArendaAdmin/Index">Главное меню</a> > <a href="/ArendaAdmin/HotelList">Список отелей</a> > <a href="/ArendaAdmin/EditHotel?HotelId=<%= ViewData["HotelId"] %>">Вернуться назад</a> > <a href="/ArendaAdmin/EditHotel?HotelId=<%= Request.QueryString["HotelId"] %>">Редактирование отеля</a>
    <br />
    <table>
    <h2>Администрирование: Редактирование фото отеля <%= ViewData["txtName"]%> <%=ViewData["HotelId"]%></h2>
    <table>
        <tr valign="top">
            <td style="width: 450px;">
                <div style="width: 350px;">
                    <fieldset>
                        <h2>Фото галерея отеля (Ш400хВ300)</h2>
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
                        <h2>Загрузить основную картинку</h2>
                        <table style="vertical-align: top; width: 100%; white-space: nowrap; font-weight: bold;">
                            <tr>
                                <td colspan="4">
                                    <% using (Html.BeginForm("UploadImg", "ArendaAdmin", FormMethod.Post, new { enctype = "multipart/form-data", }))
                                    {%>
                                            Загрузить картинку (Ш150хВ114):<br />
                                            <input type="file" id="fileUpload" name="fileUpload" size="23"/>
                                            <input type="submit" value="Загрузить" />
                                 
                                            <input type="text" visible="false" style="display: none;" id="txtHotelId" name="txtHotelId" value="<%= ViewData["HotelId"] %>" />
                                        <% } %>      
                                </td>
                            </tr>
                        </table> 
                        <div style="float: left; position: relative;">
                        <% if (Session["ImageUploaded"] != null) { %>
                            <img src="../../Content/UserImages/HotelImages/hotel_th_<%= ViewData["HotelId"] %>.jpg" alt="" /><br />
                            <a href="#" id="imgDelete<%= ViewData["HotelId"] %>" onclick="return RemoveHotelThumbImage(<%= ViewData["HotelId"] %>);">Удалить основное фото</a>
                        <% } %>
                        </div>
                    </fieldset> 
                </div>
            </td>
            <td>
                <h2>Загруженные фото</h2>
                <div style="width: 500px;" id="divHotelImg"></div>        
            </td>
        </tr>
    </table>
    <a href="/ArendaAdmin/Index">Главное меню</a> > <a href="/ArendaAdmin/HotelList">Список отелей</a> > <a href="/ArendaAdmin/EditHotel?HotelId=<%= ViewData["HotelId"] %>">Вернуться назад</a> > <a href="/ArendaAdmin/EditHotel?HotelId=<%= Request.QueryString["HotelId"] %>">Редактирование отеля</a>
</asp:Content>
