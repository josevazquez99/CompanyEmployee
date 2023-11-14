<%@page import="com.jacaranda.model.Employee"%>
<%@page import="com.jacaranda.model.User"%>
<%@page import="com.jacaranda.repository.DbRepository"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>


	<form>
		<div class="form-group row">
			<label for="id" class="	h1 fw-light">Login</label>

		</div>
		<div class="form-floating mb-3">
			<label for="id" class="col-4 col-form-label">ID</label>
			<div class="col-8">
				<input id="id" name="id" type="text" class="form-control">
			</div>
		</div>
		<div class="form-floating mb-3">
			<label for="password" class="col-4 col-form-label">Password</label> 
			<div class="col-8">
			<input
				type="password" class="form-control" id="password" name="password"
				placeholder="Enter  password">
			</div>
		</div>
		<div class="form-group row">
			<div class="offset-4 col-8">
				<button name="login" type="submit" class="btn btn-primary">Login</button>
			</div>
		</div>
	</form>
	<%
	Employee userFind;
	if (request.getParameter("login") != null) {
		try {
			userFind = DbRepository.find(Employee.class, Integer.valueOf(request.getParameter("id")));
		} catch (Exception e) {
			response.sendRedirect("error=" + e.getMessage());
			return;
		}
		if (userFind != null && userFind.getPassword().equals(request.getParameter("password"))) {
			session.setAttribute("rol", userFind.getRole());
			session.setAttribute("employee", userFind);
			response.sendRedirect("./listEmployee.jsp");
		} else {
			out.println("Id o contraseña incorrecto");
		}
	}
	%>


</body>
</html>