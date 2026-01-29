package com.mbcTeam.shop;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ProductServiceImpl implements ProductService {

	@Autowired
	private ProductDao dao;
	
	
	@Transactional
	@Override
	public void adminProductInsert(ProductVO vo) {
		dao.adminProductInsert(vo);
		
	}

	@Override
	public List<ProductVO> getSelect(ProductVO vo) {
		return dao.getSelect(vo);
	}

}
