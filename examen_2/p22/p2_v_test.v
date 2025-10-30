module p2_v_test

import p2_v

fn test_eval_pre_example() {
    tokens := '+ * + 3 4 5 7'.split(' ').filter(it != '')
    root, _ := p2_v.parse_pre(tokens, 0)
    assert p2_v.eval(root) == 42
}

fn test_eval_post_example() {
    tokens := '8 3 - 8 4 4 + * +'.split(' ')
    root := p2_v.parse_post(tokens)
    assert p2_v.eval(root) == 69
}

fn test_mostrar_pre() {
    tokens := '+ * + 3 4 5 7'.split(' ')
    root, _ := p2_v.parse_pre(tokens, 0)
    s := p2_v.to_infix(root)
    assert s == '(3 + 4) * 5 + 7'
}

fn test_mostrar_post() {
    tokens := '8 3 - 8 4 4 + * +'.split(' ')
    root := p2_v.parse_post(tokens)
    s := p2_v.to_infix(root)
    assert s == '8 - 3 + 8 * (4 + 4)'
}