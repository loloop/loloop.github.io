---
layout: main
---

# contato github please stop building this file wrong

{% for item in site.data.contact.contact %}<a href="{{item.url}}" class="inverted light"><strong>{{item.name}}</strong><span class="">{{item.id}}</span></a><br>{% endfor %}
