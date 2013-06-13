<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<Elcondor.Models.LogOnModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Вход в панель администратора
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Вход в панель администратора</h2>
    <% using (Html.BeginForm()) { %>
        <%: Html.ValidationSummary(true, "Не удалось выполнить вход. Исправьте ошибки и повторите попытку.") %>
        <div>
            <fieldset>
                <legend>Сведения учетной записи</legend>
                
                <div class="editor-label">
                <% Elcondor.Models.LogOnModel model = new Elcondor.Models.LogOnModel();
                    %>
                    <%: Html.Label("Имя пользователя")%>
                </div>
                <div class="editor-field">
                    <%: Html.TextBox("txtUserName") %>
                    <%--<%: Html.ValidationMessageFor(m => m.UserName) %>--%>
                </div>
                
                <div class="editor-label">
                    <%: Html.Label("Пароль")%>
                </div>
                <div class="editor-field">
                    <%: Html.Password("txtPassword") %>
                   <%-- <%: Html.ValidationMessageFor(m => m.Password) %>--%>
                </div>
                
                <p>
                    <input type="submit" value="Вход" />
                </p>
            </fieldset>
        </div>
    <% } %>
</asp:Content>
