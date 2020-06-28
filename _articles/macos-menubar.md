---
title: Criando um Menu Bar App no seu app Catalyst
thumbnail: 
description: 'description'
publish: false
header: 
layout: article-v2
date: '2008-09-15 14:40:45'
---

durante o desenvolvimento de focusnext

eu comi pizza

{% highlight swift linenos %}

final class Section: AnyObject {
    func reload(section: Section?) {
        guard let section = section else {
            return
        }

        section.reload(section: section)
    }
}

{% endhighlight %}