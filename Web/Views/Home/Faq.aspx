<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Турминал - Вопросы
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
	    $(document).ready(function () {
            selectTopMenuItem(<%= Elcondor.UI.Utilities.Constants.PageFaqId %>);
        });
    </script>
    <span class="mainTitle">
        <h1>Вопросы</h1>
    </span>
    <p>
        <%= ViewData["PageContent"] %>
    </p>
</asp:Content>
