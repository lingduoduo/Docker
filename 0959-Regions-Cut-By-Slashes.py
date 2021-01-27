class Solution:
    def regionsBySlashes(self, grid: List[str]) -> int:
        visit = []
        newGrid = []
        for i in grid:
            visit.append([0]*len(i)*3)
            visit.append([0] * len(i)*3)
            visit.append([0] * len(i) * 3)
            newGrid.append([0]*len(i)*3)
            newGrid.append([0] * len(i)*3)
            newGrid.append([0] * len(i) * 3)

        for i in range(len(grid)):
            for j in range(len(grid[i])):
                if grid[i][j] == '/':
                    #newGrid[2*i][2*j+1] = newGrid[2*i+1][2*j] = 1
                    newGrid[3*i][3*j+2] = newGrid[3*i+1][3*j+1] = newGrid[3*i+2][3*j] = 1
                elif grid[i][j] == '\\':
                    #newGrid[2*i][2*j] = newGrid[2*i+1][2*j+1] = 1
                    newGrid[3*i][3*j] = newGrid[3*i + 1][3*j + 1] = newGrid[3*i+2][3*j+2] = 1

        direction = [(0,1),(0,-1),(1,0),(-1,0)]
        res = 0
        for i in range(len(newGrid)):
            for j in range(len(newGrid[i])):
                if visit[i][j] == 1 or newGrid[i][j] == 1:
                    continue
                queue = [(i,j)]
                visit[i][j] = 1
                res += 1
                while len(queue) > 0:
                    x,y = queue.pop(0)
                    #visit[x][y] = 1
                    for (x1,y1) in direction:
                        nextX = x + x1
                        nextY = y + y1
                        if nextX >= 0 and nextX < len(newGrid) and nextY >= 0 and nextY < len(newGrid)\
                                and newGrid[nextX][nextY] == 0 and visit[nextX][nextY] == 0:
                            visit[nextX][nextY] = 1
                            queue.append((nextX,nextY))
        return res
