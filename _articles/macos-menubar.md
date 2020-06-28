---
title: Criando um Menu Bar App no seu app Catalyst
thumbnail: 
description: 'description'
publish: true
header: 
layout: article-v2
date: '2008-09-15 14:40:45'
---

durante o desenvolvimento de focusnext

eu comi pizza

{% highlight swift %}

final class Section: AnyObject {

    enum Type {
        public static func this(isABigLine ofCode: String) -> String {
            return ofCode
        }
    }

    func reload(section: Section?) {
        guard let section = section else {
            return
        }

        section.reload(section: section)
    }
}

{% endhighlight %}