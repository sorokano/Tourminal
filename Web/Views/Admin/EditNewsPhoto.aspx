<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактирование элемента: фото для <%= ViewData["NewsTitle"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function OnDeleteNewsThumbImage(NewsId) {
            if (confirm("Удалить фото?")) {
                $.ajax({
                    type: "POST",
                    url: "/Admin/DeleteNewsThumbImage",
                    data: "NewsId=" + NewsId,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                        }
                        location.reload();
                    }
                });
            }
        }
        function OnDeleteNewsLargeImage(NewsId) {
            if (confirm("Удалить фото?")) {
                $.ajax({
                    type: "POST",
                    url: "/Admin/DeleteNewsLargeImage",
                    data: "NewsId=" + NewsId,
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
    <a href="/Admin/Index">Главная</a> > <a href="/Admin/NewsList">Список всех элементов</a> > <%if (!Convert.ToBoolean(ViewData["NewsIsVacationType"])) { %><a href="/Admin/EditNews?id=<%=ViewData["NewsId"].ToString() %>">Редактировать <%= ViewData["NewsTitle"]%></a><%} else { %><a href="/Admin/EditVacationType?id=<%=ViewData["NewsId"].ToString() %>">Редактировать <%= ViewData["NewsTitle"]%></a> <% } %>
    <input type="hidden" id="hdnId" value="<%= ViewData["NewsId"] %>" />
    <h2>Редактирование фото <%= ViewData["NewsTitle"] %></h2>
    <div style="width: 300px;">
        <fieldset>
            <h2>Загрузить картинки</h2>
            <table style="vertical-align: top; width: 100%; white-space: nowrap; font-weight: bold;">
                <%--<tr>
                    <td colspan="4">
                        <% using (Html.BeginForm("UploadNewsThumbImg", "Admin", FormMethod.Post, new { enctype = "multipart/form-data", }))
                        {%>
                                Загрузить малую картинку(для верхнего раздела новостей). Размеры высота:270px;ширина:285px:<br />
                                <input type="file" id="fileUpload" name="fileUpload" size="23"/>
                                <input type="submit" value="Загрузить" />
                                 
                                <input type="text" visible="false" style="display: none;" id="txtNewsId" name="txtNewsId" value="<%= ViewData["NewsId"] %>" />
                            <% } %>      
                    </td>
                </tr>
                <tr>
                    <td>
                        <div style="float: left; position: relative;">
                        <% if (Convert.ToBoolean(ViewData["NewsHasThumbImage"].ToString())) { %>
                            <img src="../../Content/UserImages/news_th_<%= ViewData["NewsId"] %>.jpg" alt="" />
                            <a href="#" id="imgDelete<%= ViewData["Id"] %>" onclick="return OnDeleteNewsThumbImage(<%= ViewData["NewsId"] %>);">Удалить мал.фото [X]</a>
                        <% } %>
                        </div>
                    </td>
                </tr>--%>
                <tr>
                    <td colspan="4">
                        <% using (Html.BeginForm("UploadNewsLargeImg", "Admin", FormMethod.Post, new { enctype = "multipart/form-data", }))
                        {%>
                                Загрузить большую картинку. Размеры высота:180px;ширина:285px::<br />
                                <input type="file" id="file1" name="fileUpload1" size="23"/>
                                <input type="submit" value="Загрузить" />
                                 
                                <input type="text" visible="false" style="display: none;" id="txtNewsId" name="txtNewsId" value="<%= ViewData["NewsId"] %>" />
                            <% } %>      
                    </td>
                </tr>
                <tr>
                    <td>
                        <div style="float: left; position: relative;">
                        <% if (Convert.ToBoolean(ViewData["NewsHasLargeImage"].ToString())) { %>
                            <img src="../../Content/UserImages/news_<%= ViewData["NewsId"] %>.jpg" alt="" />
                            <a href="#" id="A1" onclick="return OnDeleteNewsLargeImage(<%= ViewData["NewsId"] %>);">Удалить бол.фото [X]</a>
                        <% } %>
                        </div>
                    </td>
                </tr>
            </table> 
            
        </fieldset> 
    </div>
</asp:Content>
