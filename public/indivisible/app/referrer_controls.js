/*This script will provide methods for controlling which users see what, based on referrer codes. */

optInChk = $("#name_optin1");
optInCtls = $('li#d_sharing');
try {
  var doc = yaml.safeLoad(fs.readFileSync('referrers.yaml', 'utf8'));
  console.log(doc);
} catch (e) {
  console.log(e);
}