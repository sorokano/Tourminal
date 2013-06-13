<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= ViewData["PageTitle"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
	    $(document).ready(function () {

        });
    </script>
    <span class="mainTitle">
        <h1><%= ViewData["PageTitle"] %></h1>
    </span>
    <p>
        <%= ViewData["PageContent"] %>
    </p>

</asp:Content>
