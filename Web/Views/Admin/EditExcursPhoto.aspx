<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактирование фото экскурсии: "<%= ViewData["TourName"] + "\", " + ViewData["RegionName"] + " (" + ViewData["CountryName"] + ")" %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function OnDeleteThumbImage(tourId) {
            if (confirm("Удалить фото?")) {
                $.ajax({
                    type: "POST",
                    url: "/Admin/DeleteTourThumbImage",
                    data: "tourId=" + tourId,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                        }
                        location.reload();
                    }
                });
            }
        }
    </script>
    <input type="hidden" id="hdnId" value="<%= ViewData["TourId"] %>" />
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../Admin/ExcursList">Список экскурсий</a> > <a href="../../Admin/ExcursEdit?id=<%= ViewData["TourId"] %>">Редактировать экскурсии <%= ViewData["TourName"]%></a>
    <br />
    <table>
    <h2>Редактирование фото экскурсии: "<%= ViewData["TourName"] + "\", " + ViewData["RegionName"] + " (" + ViewData["CountryName"] + ")" %></h2>
    <table>
        <tr valign="top">
            <td style="width: 450px;">
                <div style="width: 300px;">
                    <fieldset>
                        <h2>Загрузить картинку (200пикс на 180пикс)</h2>
                        <table style="vertical-align: top; width: 100%; white-space: nowrap; font-weight: bold;">
                            <tr>
                                <td colspan="4">
                                    <% using (Html.BeginForm("UploadTourImg", "Admin", FormMethod.Post, new { enctype = "multipart/form-data", }))
                                    {%>
                                    Загрузить картинку:<br />
                                    <input type="file" id="fileUpload" name="fileUpload" size="23"/>
                                    <input type="submit" value="Загрузить" />
                                 
                                    <input type="text" visible="false" style="display: none;" id="txtId" name="txtId" value="<%= ViewData["TourId"] %>" />
                                    <% } %>      
                                </td>
                            </tr>
                        </table> 
                        <div style="float: left; position: relative;">
                        <% if (Session["ImageUploaded"] != null) { %>
                            <img src="../../Content/UserImages/tour_th_<%= ViewData["TourId"] %>.jpg" alt="" />
                            <a href="#" id="imgDelete<%= ViewData["TourId"] %>" onclick="return OnDeleteThumbImage(<%= ViewData["TourId"] %>);">Удалить фото [X]</a>
                        <% } %>
                        </div>
                    </fieldset> 
                </div>
            </td>
        </tr>
    </table>
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../Admin/ExcursList">Список экскурсий</a> > <a href="../../Admin/ExcursEdit?id=<%= ViewData["TourId"] %>">Редактировать экскурсии <%= ViewData["TourName"]%></a>
</asp:Content>