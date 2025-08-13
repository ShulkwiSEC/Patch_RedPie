from werkzeug.debug import DebuggedApplication
from flask import Flask,render_template,redirect,request,url_for,jsonify,Response,render_template_string
import random
import os

# set some env varible
os.environ['WERKZEUG_DEBUG_PIN'] = str(random.randint(1000, 9999))

# App
app = Flask(__name__,static_folder='templates/static/')

app.wsgi_app = DebuggedApplication(
    app.wsgi_app,
    console_init_func=None,
    show_hidden_frames=False,
    pin_security=True,
    pin_logging=True
)

@app.route('/', defaults={'path': 'index'})
@app.route('/<path:path>')

def load_page(path):
    if path == 'json_calc':
        x = request.query_string
        g = {"__builtins__": None}
        l = {}
        try:
            exec(x, g, l)
            return jsonify(l)
        except Exception as e:
            return jsonify({'error': str(e)})
    else:
        try:
            with open('templates/' + path + '.html', 'r') as myfile:
                return myfile.read()
        except Exception as e:
            return render_template_string("""
            <h1>404</h1>
            <p>Page not found</p>
            """)