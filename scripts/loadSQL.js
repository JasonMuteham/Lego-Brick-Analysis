async function loadsql(sqlFile) {
  if (!sqlFile) { return; }
  let text = await downloadFile(sqlFile);
  let sqlText = text.split("\n\n");

  let len = sqlText.length;
  let i = 0;

  var sqlDefaultTxt = ''

  for (; i < len;) {

    let defaultsql = sqlText[i];
    console.log(defaultsql);
    if (defaultsql.indexOf("*markdown") > 0) {
      console.log('markdown');
      defaultsql = defaultsql.replace('/*markdown','')
      defaultsql = defaultsql.replace('*/','')
      sqlDefaultTxt = `${sqlDefaultTxt}<md-block>${defaultsql}</md-block>`;
    } else {
      console.log('code');
      sqlDefaultTxt = `${sqlDefaultTxt}<sql-exercise data-default-text="${defaultsql}"></sql-exercise>`;
    }

    i++;
  }

  const h2 = document.getElementById("mySQL");
  h2.insertAdjacentHTML("afterend", sqlDefaultTxt);

}
async function downloadFile(sqlFile) {

  let response = await fetch(sqlFile);

  if (response.status != 200) {
    throw new Error("Server Error");
  }

  // read response stream as text
  let text_data = await response.text();

  return text_data;
}