<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Article.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - туристическая компания: Поиск по тэгу
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a> <img src="../../Content/Images/greenarrow.png"/> <a href="../../CountryAbout?id=<%= ViewData["CountryId"]%>"> <%=ViewData["CountryName"] %></a> <img src="../../Content/Images/greenarrow.png"/> Поиск по тэгу
    </div>
    <h2>
        Поиск по тэгу: <%=ViewData["CountryName"] %>
        <% if (ViewData["CountryId"] != null)
               if (ViewData["CountryId"].ToString() != "-1")
            if (ElcondorBiz.BizCountry.HasCountryFlag(int.Parse(ViewData["CountryId"].ToString()))) { %> 
            <img src="../../Content/UserImages/flag_<%=ViewData["CountryId"] %>.jpg" alt="" style="height: 30px;vertical-align: middle;" />
        <% } %> - <%=ViewData["TagName"] %>
    </h2>
    <%= ViewData["GridArticleList"] %>
</asp:Content>
