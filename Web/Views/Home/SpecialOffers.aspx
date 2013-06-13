<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Tour.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - Специальные предложения
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">    
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btncountrytours").addClass("selected");
            $.getJSON('http://tourminal.ru/ElcondorWCF.svc/GetCountryListWithToursJS' + "?method=?&" + "countryId=" + $.query.get("id"), function (response) {
                var result = "";
                var items = eval('(' + response + ')');
                for (var i = 0; i < items.length; i++) {
                    result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                }
                $("select#" + 'ddlCountry').html(result);
                $("select#ddlCountry").val($.query.get("id"));
            });
            $("#ddlCountry").change(function (e) {
                document.location = '../../CountryTours?id=' + $(this).val();
            });
        });
    </script>
    <div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a> <img src="../../Content/Images/greenarrow.png"/> Специальные предложения
    </div>
    <div id="topmenu">
        Сортировать по:&nbsp;&nbsp; <a href="#" id="btnsortpopular" class="topmenuitem">популярности</a> 
        <a href="#" id="btnsortcountry" class="topmenuitem selected">По стране</a> &nbsp;&nbsp; 
        <%= Html.DropDownList("ddlCountry", new List<SelectListItem>())%>  
    </div>
    <%--<h2>Маршруты: <%= ViewData["CountryName"] %>  
        <% if (ElcondorBiz.BizCountry.HasCountryFlag(int.Parse(ViewData["CountryId"].ToString())) /) { %> 
            <img src="../../Content/UserImages/flag_<%=ViewData["CountryId"] %>.jpg" alt="" style="h /eight: 30px;vertical-align: middle;" />
        <% } % />
    </h2>--%>
    <%= ViewData["GridList"] %>
</asp:Content>
