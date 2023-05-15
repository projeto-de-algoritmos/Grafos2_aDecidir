import heapq

def prim(grafo): #vai entrar como uma lista
    n = len(grafo) #guardar tamanho da lista no n
    
    visitado = [False] * n 
    pq = [(0, 0)] # (custo, no) 
    custo_arvore = 0

    while pq:
        custo, u = heapq.heappop(pq)
        if visitado[u]:
            continue
        visitado[u] = True
        custo_arvore = custo + custo_arvore
        for v, w in grafo[u]:
            if not visitado[v]:
                heapq.heappush(pq, (w, v))

    return custo_arvore


while True:
    m, n = map(int, input().split())
    if m == n == 0:
        break
    
    grafoTeste = [[] for _ in range(m)]
    for _ in range(n):
        x, y, z = map(int, input().split()) #entrada de dados
        grafoTeste[x].append((y, z))
        grafoTeste[y].append((x, z))
    custo_arvore = prim(grafoTeste)
    print(custo_arvore)


