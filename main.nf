process downloadTree {
    output:
    path "ref.nw.gz"

    script:
    """
    wget https://booster.pasteur.fr/static/files/primates/ref.nw.gz
    """
}

process statsTips {
    publishDir "results", mode: 'copy'

    input:
    path tree

    output:
    path "tips.txt"

    script:
    """
    gotree stats tips -i $tree > tips.txt
    """
}

workflow {
    tree_ch = downloadTree()
    tips_ch = statsTips(tree_ch)

    tips_ch
        .splitCsv(header: true, sep: '\t')
        .count()
        .view { count -> "Nombre total de tips : $count" }
}
