from flask import Flask, request, jsonify, render_template
from openai import OpenAI
import os

app = Flask(__name__, static_folder="static")

# Create the OpenAI client using new SDK
client = OpenAI(api_key=os.getenv("OPENAI_KEY"))

@app.route("/", methods=["GET", "POST"])
def index():
    response = None
    if request.method == "POST":
        prompt = request.form.get("prompt")
        if prompt:
            try:
                completion = client.chat.completions.create(
                    model="gpt-4",
                    messages=[{"role": "user", "content": prompt}]
                )
                response = completion.choices[0].message.content.strip()
            except Exception as e:
                response = f"Error: {e}"
    return render_template("index.html", response=response)

@app.route("/ask", methods=["POST"])
def ask_api():
    data = request.get_json()
    prompt = data.get("prompt")
    if not prompt:
        return jsonify({"error": "Missing prompt"}), 400
    try:
        completion = client.chat.completions.create(
            model="gpt-4",
            messages=[{"role": "user", "content": prompt}]
        )
        answer = completion.choices[0].message.content.strip()
        return jsonify({"response": answer})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/healthz")
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
