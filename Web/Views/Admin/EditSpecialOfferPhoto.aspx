<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактирование спецпредложения: фото <%= ViewData["Title"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            function OnDeleteSpecialOfferThumbImage(specialOfferId) {
                if (confirm("Удалить фото?")) {
                    $.ajax({
                        type: "POST",
                        url: "/Admin/DeleteSpecialOfferThumbImage",
                        data: "specialOfferId=" + specialOfferId,
                        success: function(msg) {
                            if (msg == '"error"') {
                                msg = msg + " - произошла ошибка. Попробуйте снова.";
                            }
                            location.reload();
                        }
                    });
                }
            }
        });
    </script>
    <a href="/Admin/Index">Главная</a> > <a href="/Admin/SpecialOffers">Список спец.предложений</a> > <a href="/Admin/EditSpecialOffer?id=<%=ViewData["SpecialOfferId"].ToString() %>">Редактирование спец.предложения</a>
    <input type="hidden" id="hdnId" value="<%= ViewData["SpecialOfferId"] %>" />
    <h2>Редактирование спецпредложения: фото <%= ViewData["Title"] %></h2>
    <div style="width: 300px;">
        <fieldset>
            <h2>Загрузить основную картинку(W200xH180)</h2>
            <table style="vertical-align: top; width: 100%; white-space: nowrap; font-weight: bold;">
                <tr>
                    <td colspan="4">
                        <% using (Html.BeginForm("UploadSpecialOfferImg", "Admin", FormMethod.Post, new { enctype = "multipart/form-data", }))
                        {%>
                                Загрузить картинку:<br />
                                <input type="file" id="fileUpload" name="fileUpload" size="23"/>
                                <input type="submit" value="Загрузить" />
                                 
                                <input type="text" visible="false" style="display: none;" id="txtSpecialOfferId" name="txtSpecialOfferId" value="<%= ViewData["SpecialOfferId"] %>" />
                            <% } %>      
                    </td>
                </tr>
            </table> 
            <div style="float: left; position: relative;">
            <% if (Session["ImageUploaded"] != null) { %>
                <img src="../../Content/UserImages/specialoffer_th_<%= ViewData["SpecialOfferId"] %>.jpg" alt="" />
                <a href="#" id="imgDelete<%= ViewData["Id"] %>" onclick="return OnDeleteSpecialOfferThumbImage(<%= ViewData["SpecialOfferId"] %>);">Удалить фото [X]</a>
            <% } %>
            </div>
        </fieldset> 
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
