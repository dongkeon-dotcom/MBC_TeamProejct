package com.mbcTeam.order;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao dao;

    @Override
    public void insertOrder(OrderVO order, OrderItemVO item) {
        dao.insertOrder(order, item);
    }

    @Override
    public void insert(OrderVO vo) {
        dao.insert(vo);
    }

    @Override
    public List<OrderVO> select(OrderVO vo) {
        return dao.select(vo);
    }

    @Override
    public void update(OrderVO vo) {
        dao.update(vo);
    }

    @Override
    public void delete(OrderVO vo) {
        dao.delete(vo);
    }
}
