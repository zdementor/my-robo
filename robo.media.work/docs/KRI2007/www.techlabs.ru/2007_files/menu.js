function showMenu(nr)
  {
    document.getElementById('m2').style.display = 'none';
    document.getElementById('m3').style.display = 'none';
    document.getElementById('m4').style.display = 'none';
    document.getElementById('m5').style.display = 'none';
    document.getElementById('m6').style.display = 'none';
    document.getElementById('m7').style.display = 'none';
    document.getElementById('m8').style.display = 'none';
    document.getElementById('m9').style.display = 'none';

    current = (document.getElementById(nr).style.display == 'none') ? 'block' : 'none';
    document.getElementById(nr).style.display = current;
}

function active(nr)
  {
    document.getElementById('a2').className = 'notactive';
    document.getElementById('a3').className = 'notactive';
    document.getElementById('a4').className = 'notactive';
    document.getElementById('a5').className = 'notactive';
    document.getElementById('a6').className = 'notactive';
    document.getElementById('a7').className = 'notactive';
    document.getElementById('a8').className = 'notactive';
    document.getElementById('a9').className = 'notactive';

    current = (document.getElementById(nr).className == 'notactive') ? 'active' : 'notactive';
    document.getElementById(nr).className = current;
}