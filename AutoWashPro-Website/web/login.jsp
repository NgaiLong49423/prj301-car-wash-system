<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>

        <style>

            body{
                font-family: Arial;
                background: #f2f2f2;
            }

            .login-box{
                width: 300px;
                margin: 100px auto;
                background: white;
                padding: 20px;
                border-radius: 10px;
            }

            input{
                width: 100%;
                padding: 10px;
                margin-top: 10px;
            }

            button{
                width: 100%;
                padding: 10px;
                margin-top: 15px;
                background: dodgerblue;
                color: white;
                border: none;
            }

            .error{
                color: red;
            }

        </style>

    </head>

    <body>

        <div class="login-box">

            <h2>Login</h2>

            <form action="login" method="post">

                email:
                <input type="text" name="email">

                <br><br>

                Password:
                <input type="password" name="password">

                <br><br>

                <button type="submit">
                    Login
                </button>

            </form>

            <p class="error">
                ${error}
            </p>

        </div>

    </body>
</html>