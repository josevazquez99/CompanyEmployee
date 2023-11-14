<%@page import="com.jacaranda.model.EmployeeProject"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.chrono.ChronoLocalDateTime"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.Date"%>
<%@page import="com.jacaranda.model.CompanyProject"%>
<%@page import="com.jacaranda.model.Project"%>
<%@page import="com.jacaranda.model.Employee"%>
<%@page import="com.jacaranda.model.User"%>
<%@page import="com.jacaranda.repository.DbRepository"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add hours project</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
	<%
	if (session.getAttribute("employee") != null) {
	%>
	<%@include file="nav.jsp"%>

	<%
	if (request.getParameter("save") != null) {
	%>
	<%
	if (session.getAttribute("time") != null) {
		int seconds = (int) ChronoUnit.SECONDS.between(((LocalDateTime) session.getAttribute("time")), LocalDateTime.now());
		if (session.getAttribute("cont") == null) {
			session.setAttribute("cont", 0);
		}
		session.setAttribute("cont", (int) session.getAttribute("cont") + seconds);

		Project p = null;
		if (request.getParameter("idProject") != null) {
			p = DbRepository.find(Project.class, Integer.valueOf(request.getParameter("idProject")));
		}
		Employee e = null;
		try {
			e = ((Employee) session.getAttribute("employee"));
		} catch (Exception ex) {
			response.sendRedirect("msgError.jsp?error=" + ex.getMessage());
			return;
		}
		int cont = 0;
		if (session.getAttribute("cont") != null) {
			cont = (int) session.getAttribute("cont");
		}
		EmployeeProject ep = new EmployeeProject(p, e, cont);
		if (DbRepository.find(ep) != null) {
			ep.setMinute(DbRepository.find(ep).getMinute() + cont);
			DbRepository.editEntity(ep);
		} else {
			DbRepository.addEntity(ep);
		}
		session.removeAttribute("cont");
		session.removeAttribute("time");
		session.removeAttribute("project");
	}
	}
	%>
	<div class="card-body p-4">
		<div class="text-center">
			<div class="h1 fw-light">Add hours project</div>
		</div>
		<form>
			<%
			if (request.getParameter("start") == null && session.getAttribute("time") == null) {
			%>
			<div class="form-floating mb-3">
				<label for="projects" class="form-label">Project's</label>
				<select id="projects" name="projects" class="custom-select">
					<%
					Employee e = (Employee) session.getAttribute("employee");
					for (CompanyProject cp : e.getCompany().getCompanyProject()) {
						if (cp.getEnd().after(Date.valueOf(LocalDate.now()))) { //Aqui compruebo que el proyecto está activo y lo muestro
					%>
					<option value="<%=cp.getProject().getId()%>"><%=cp.getProject().getName()%></option>
					<%}%>
					<%}%>
				</select>

			</div>
			<%
			} else if (request.getParameter("start") != null || session.getAttribute("time") != null) {
			if (session.getAttribute("project") == null) {
				session.setAttribute("project",
				DbRepository.find(Project.class, Integer.valueOf(request.getParameter("projects"))));
			}
			%>
			<div class="form-floating mb-3">
				<label for="project" class="form-label">Project</label> <input
					type="text" class="form-control" id="project" name="project"
					value="<%=((Project) session.getAttribute("project")).getName()%>"
					readonly> <input type="text" class="form-control"
					id="idProject" name="idProject"
					value="<%=((Project) session.getAttribute("project")).getId()%>"
					hidden>
			</div>
			<%}%>
			<div class="d-grid">
				<%
				if (request.getParameter("start") == null && session.getAttribute("time") == null) {//Muestro el botón cuando no haya empezado
				%>
				<button class="btn btn-primary btn-lg" id="start" value="start"
					type="submit" name="start">Start</button>
				<%
				} else {
				if (session.getAttribute("time") == null) {
					LocalDateTime ldt = LocalDateTime.now();
					session.setAttribute("time", ldt);
				}
				%>

				<%
				if (session.getAttribute("time") != null) {
				%>
				<button class="btn btn-danger btn-lg" id="save" value="save"
					type="submit" name="save">Save</button>
				<%}%>
				<%}%>

			</div>
			<button class="btn btn-info btn-ms mt-2" id="nameE" value="nameE"
				type="button" name="nameE"><%=((Employee) session.getAttribute("employee")).getFirstName()%></button>
	</div>
		</form>

	<%
	} else {
	response.sendRedirect("./login.jsp");
	}
	%>
</body>
</html>