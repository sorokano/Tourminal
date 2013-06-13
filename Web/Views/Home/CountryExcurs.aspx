<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Tour.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - туристическая компания: Экскурсии в стране <%=ViewData["CountryName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a> <img src="../../Content/Images/greenarrow.png"/> <a href="../../CountryAbout?id=<%= ViewData["CountryId"]%>"> <%=ViewData["CountryName"] %></a> <img src="../../Content/Images/greenarrow.png"/> Экскурсии
    </div>
    <h2>Экскурсии: <%= ViewData["CountryName"] %>  
        <% if (ElcondorBiz.BizCountry.HasCountryFlag(int.Parse(ViewData["CountryId"].ToString()))) { %> 
            <img src="../../Content/UserImages/flag_<%=ViewData["CountryId"] %>.jpg" alt="" style="height: 30px;vertical-align: middle;" />
        <% } %></h2>
    <%= ViewData["GridList"] %>
</asp:Content>
